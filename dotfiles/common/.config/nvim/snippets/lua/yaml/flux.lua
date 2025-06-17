return {
    -- FluxCD Kustomization
    s("fluxkustomization", fmt([[
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: {kustomization_name}
  namespace: {namespace}
spec:
  dependsOn:
    - name: {dependency_name}
  interval: {interval}
  retryInterval: {retry_interval}
  timeout: {timeout}
  sourceRef:
    kind: {source_kind}
    name: {source_name}
  path: {path}
  prune: {prune}
  wait: {wait}
  postBuild:
    substitute:
      cluster_name: "{cluster_name}"
    substituteFrom:
      - kind: ConfigMap
        name: {configmap_name}
        optional: {optional}
]], {
        kustomization_name = i(1, "name"),
        namespace = i(2, "default"),
        dependency_name = i(3, "dependency"),
        interval = i(4, "1h"),
        retry_interval = i(5, "1m"),
        timeout = i(6, "5m"),
        source_kind = i(7, "GitRepository"),
        source_name = i(8, "flux-system"),
        path = i(9, "path/to/kustomization"),
        prune = i(10, "true"),
        wait = i(11, "true"),
        cluster_name = i(12, "staging"),
        configmap_name = i(13, "scaleway-info"),
        optional = i(14, "false"),
    }
    )),


    -- FluxCD HelmRepository
    s("fluxhelmr", fmt([[
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository

metadata:
  name: {}
  namespace: {}
spec:
  interval: {}
  url: {}
  timeout: {}
]], {
        i(1, "my-helmrepo"),
        i(2, "flux-system"),
        i(3, "1m0s"),
        i(4, "https://charts.example.com/"),
        i(5, "60s"),
    })),

    -- FluxCD HelmRelease
    s("fluxhelmrelease", fmt([[
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {name}
  namespace: {namespace}
spec:
  interval: {interval}
  chart:
    spec:
      chart: {chart}
      version: {version}
      sourceRef:
        kind: HelmRepository
        name: {repo_name}
        namespace: {repo_namespace}
      interval: {source_interval}
  values:
    {values}
]], {
        name = i(1, "name"),
        namespace = i(2, "default"),
        interval = i(3, "5m0s"),
        chart = i(4, "my-chart"),
        version = i(5, "1.2.3"),
        repo_name = i(6, "my-helmrepo"),
        repo_namespace = i(7, "flux-system"),
        source_interval = i(8, "1h"),
        values = i(9, "key: value"),
    })),
}
