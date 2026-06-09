const cds = require("@sap/cds");

// In-memory SQLite needs an explicit schema deploy + CSV seeding on
// startup. cds-serve only does this automatically under the
// development profile - in production we have to run cds.deploy
// ourselves.
cds.on("served", async () => {
  const db = await cds.connect.to("db");
  await cds.deploy(cds.model).to(db);
});

module.exports = cds.server;
