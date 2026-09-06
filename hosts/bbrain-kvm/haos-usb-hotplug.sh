# Hot-attaches a Nabu Casa ZBT-2 USB dongle to the "haos" libvirt domain the
# moment udev sees it appear, live, using the exact bus/device numbers udev
# observed for it at that instant. This sidesteps every problem with static
# matching: two physical dongles share the same vendor:product id (so
# matching by vendor/product alone is ambiguous), and USB bus numbers are
# reassigned by the kernel on every boot (observed bus 3 -> bus 1 across
# consecutive boots on this host), so a value baked into the domain XML goes
# stale. Matching at the moment of the actual add event has neither problem.
#
# Dispatched via `systemd-run --no-block` from a udev rule rather than run
# inline - this must NOT block the udev worker. libvirtd is ordered
# `After=systemd-udev-settle.service`, and udev-settle waits for queued
# RUN+= programs to finish. If this script blocked here waiting for the VM
# to start, and the VM can't start until libvirtd starts, and libvirtd won't
# start until udev settles - that's a boot deadlock. Running as an
# independent detached unit avoids it entirely.
set -eu

export PATH=/run/current-system/sw/bin:$PATH

DOMAIN="haos"
LOG=/var/log/haos-usb-hotplug.log
BUS=$((10#${BUSNUM:?BUSNUM not set}))
DEV=$((10#${DEVNUM:?DEVNUM not set}))

log() {
  echo "$(date -Iseconds) $*" >> "$LOG"
}

log "add event bus=$BUS dev=$DEV serial=${ID_SERIAL_SHORT:-unknown}"

state=""
for i in $(seq 1 120); do
  state=$(virsh -c qemu:///system domstate "$DOMAIN" 2>/dev/null || echo "")
  [ "$state" = "running" ] && break
  sleep 1
done

if [ "$state" != "running" ]; then
  log "gave up waiting for $DOMAIN to be running"
  exit 0
fi

XML=$(mktemp)
trap 'rm -f "$XML"' EXIT
cat > "$XML" <<EOF
<hostdev mode='subsystem' type='usb' managed='yes'>
  <source>
    <vendor id='0x303a'/>
    <product id='0x831a'/>
    <address bus='$BUS' device='$DEV'/>
  </source>
</hostdev>
EOF

if OUT=$(virsh -c qemu:///system attach-device "$DOMAIN" "$XML" --live 2>&1); then
  log "attached bus=$BUS dev=$DEV: $OUT"
else
  log "FAILED to attach bus=$BUS dev=$DEV: $OUT"
fi
