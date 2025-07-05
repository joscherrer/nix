local probeType = function(t)
    return t .. "Probe:" .. "\n"
end

local probeCommon = [[
  initialDelaySeconds: {initial_delay_seconds}
  periodSeconds: {period_seconds}
  timeoutSeconds: {timeout_seconds}
  failureThreshold: {failure_threshold}
  successThreshold: {success_threshold}
]]

local probeExec = [[
  exec:
    command: ["{command}"]
]] .. probeCommon

local probeHttp = [[
  httpGet:
    port: {port}
    host: {host}
    path: {path}
    scheme: {scheme}
    httpHeaders:
     - name: {header_name}
       value: {header_value}
]] .. probeCommon

local probeCommonParams = function(idx)
    return {
        initial_delay_seconds = i(idx + 1, "20"),
        period_seconds = i(idx + 2, "10"),
        timeout_seconds = i(idx + 3, "1"),
        failure_threshold = i(idx + 4, "3"),
        success_threshold = i(idx + 5, "1"),
    }
end

local probeExecParams = function()
    return vim.deepcopy(vim.tbl_extend('keep', {
        command = i(1, "curl")
    }, probeCommonParams(1)))
end

local probeHttpParams = function()
    return vim.deepcopy(vim.tbl_extend('keep', {
        port = i(1, "80"),
        host = i(2, "localhost"),
        path = i(3, "/"),
        scheme = i(4, "HTTP"),
        header_name = i(5, "Authorization"),
        header_value = i(6, "Bearer <token>"),
    }, probeCommonParams(6)))
end


local function getProbeFmt(type, action, actionParams)
    local r = probeType(type)

    return fmt(r .. action, actionParams)
end



return {
    s("kustomization", {
        t({ "apiVersion: kustomize.config.k8s.io/v1beta1", "kind: Kustomization", "", "namespace: " }),
        i(1, "your-namespace"),
    }),
    s({ trig = "namespace" }, fmt([[
apiVersion: v1
kind: Namespace
metadata:
  name: {namespace}
  annotations:
    kustomize.toolkit.fluxcd.io/prune: "disabled"
    ]],
        {
            namespace = i(1, "default")
        })),
    s({ trig = "livenessExec" }, getProbeFmt("liveness", probeExec, probeExecParams())),
    s({ trig = "livenessHttp" }, getProbeFmt("liveness", probeHttp, probeHttpParams())),
    s({ trig = "readinessExec" }, getProbeFmt("readiness", probeExec, probeExecParams())),
    s({ trig = "readinessHttp" }, getProbeFmt("readiness", probeHttp, probeHttpParams())),
}
