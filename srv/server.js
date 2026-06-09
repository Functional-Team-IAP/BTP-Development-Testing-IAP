const cds = require("@sap/cds");
const proxy = require("@sap/cds-odata-v2-adapter-proxy");

// Mount the OData V2 adapter proxy in front of the CAP server.
// It exposes every V4 service at /odata/v2/<service-path>, which
// the SAP Fiori Elements V2 templates (sap.suite.ui.generic.template)
// require since they speak OData V2.
cds.on("bootstrap", (app) => {
  app.use(proxy());
});

module.exports = cds.server;
