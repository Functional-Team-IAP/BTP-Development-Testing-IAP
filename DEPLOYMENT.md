# Deploy to SAP BTP — step-by-step

The repo already contains everything needed for a Cloud Foundry MTA deploy:
`mta.yaml`, `xs-security.json`, the `approuter/` module, and a CAP service
build. You just need a BTP subaccount with the right entitlements and the
tooling to run `mbt build` + `cf deploy`.

The easiest path is **SAP Business Application Studio (BAS)** — a
browser-based dev environment on BTP where `cf`, `mbt`, Node.js, and the
multiapps plugin are all pre-installed.

---

## Path A — From SAP Business Application Studio (no local install)

### A1. Set up your BTP subaccount (one-time)

In the [BTP Cockpit](https://cockpit.btp.cloud.sap):

1. **Subaccount → Entitlements → Configure Entitlements →
   Add Service Plans**. Add:
   - **SAP HANA Cloud** — plan `hdi-shared` (and `tools`)
   - **Authorization and Trust Management Service** (xsuaa) — `application`
   - **HTML5 Application Repository Service** — both `app-host` and `app-runtime`
   - **Destination Service** — `lite`
   - **SAP Business Application Studio** — `standard-edition`
   - **Cloud Foundry Runtime** — at least 1 GB of MEMORY
2. **Subaccount → Cloud Foundry Environment** → enable CF, create a **Space**
   (e.g. `dev`).
3. **Service Marketplace → SAP HANA Cloud** → create a HANA Cloud instance in
   the space. **Wait for it to reach RUNNING** (15-30 min the first time).

### A2. Open BAS

1. **Instances and Subscriptions → SAP Business Application Studio →
   Go to Application**.
2. **Create Dev Space** → name `bp-sales` → template **Full Stack Cloud
   Application** → **Create**.
3. When it says **RUNNING**, click it to open.

### A3. Get the code into BAS

Open a Terminal (`☰ → Terminal → New Terminal`):

```bash
cd ~/projects
git clone <your repo URL> bp-sales
cd bp-sales
git checkout claude/adoring-pascal-r2s39l
```

### A4. Log in to Cloud Foundry

In the same terminal — copy the API endpoint URL from
**BTP Cockpit → Subaccount → Cloud Foundry**:

```bash
cf api https://api.cf.<region>.hana.ondemand.com
cf login --sso        # one-time SSO code in the browser
cf target -o <your org> -s <your space>
```

### A5. Build and deploy

```bash
npm install
cd app/businesspartnersalesorders && npm install && cd ../..
npm run build              # produces mta_archives/archive.mtar
cf deploy mta_archives/archive.mtar
```

First-time deploy takes 5-10 min. It creates HANA HDI / XSUAA /
html5-apps-repo / destination service instances, pushes the CAP backend and
the approuter, and uploads the Fiori app to the HTML5 repository.

### A6. Grant yourself the role and open the app

1. **BTP Cockpit → Subaccount → Security → Role Collections** →
   **BPSalesViewerRC** → **Edit** → add your email under **Users** → **Save**.
2. **Instances and Subscriptions → HTML5 Applications** → click
   **Business Partner Sales Orders**.

In the real BTP Launchpad, FE V4 has full access to shell services, so
the analytical features (`$apply` aggregation, real subtotals, charts) that
were unreliable locally will work correctly.

---

## Path B — From your own laptop

Install once:

```bash
# Node.js 22 LTS  (https://nodejs.org/en/download)
npm install -g @sap/cds-dk mbt
# Cloud Foundry CLI v8  (https://github.com/cloudfoundry/cli/releases)
cf install-plugin multiapps -f
```

Then the same **A4 → A5 → A6** steps.

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `cf deploy: command not found` | `cf install-plugin multiapps -f` |
| `Error creating service btp-bp-sales-db ... not entitled` | Add the `hana` `hdi-shared` plan in Entitlements |
| Approuter starts but shows **403 Forbidden** | Assign `BPSalesViewerRC` to your user (A6) |
| `npm run build` fails on `mbt: not found` | BAS has it pre-installed; locally do `npm install -g mbt` |
| HANA Cloud instance still **CREATING** | Wait until **RUNNING** before `cf deploy` |
| App opens but table is empty | `cf logs btp-bp-sales-srv --recent` - usually a HANA HDI deploy issue, or the role just hasn't propagated (log out / in) |

---

## What gets created in your BTP space

After a successful deploy, **Subaccount → Cloud Foundry → Space → Services**
will show:

- `btp-bp-sales-db` (HANA HDI container)
- `btp-bp-sales-uaa` (XSUAA application)
- `btp-bp-sales-html5-repo-host` and `btp-bp-sales-html5-repo-rt`
- `btp-bp-sales-destination`

Under **Applications**: `btp-bp-sales-srv` and `btp-bp-sales-approuter`.

## Undeploying

To remove everything:

```bash
cf undeploy btp-business-partner-sales-orders --delete-services --delete-service-keys
```
