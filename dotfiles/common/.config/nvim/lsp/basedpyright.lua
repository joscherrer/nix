return {
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}
