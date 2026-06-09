# Business Partner Sales Orders — Fiori Elements List Report

A SAP Cloud Application Programming Model (CAP, Node.js) service that exposes
Business Partner sales orders as OData V4, paired with a SAPUI5 Fiori Elements
**List Report** demonstrating the annotation-driven **grouping** feature
described in the SAP community blog [*Fiori Elements List Report — sorting,
grouping and table types*](https://community.sap.com/t5/technology-blog-posts-by-sap/fiori-elements-list-report-sorting-grouping-and-table-types/ba-p/13350422/page/2).

---

## Run locally (zero BTP setup required)

You only need **Node.js 20+** installed.

```bash
# 1. Install dependencies (first time only)
npm install

# 2. Start the server
npm start
```

That's it. The terminal will print something like:

```
[cds] - server listening on { url: 'http://localhost:4004' }
```

Open **http://localhost:4004** in your browser. You'll see a CAP welcome
page with two links worth knowing:

| Link | What it shows |
| --- | --- |
| `businesspartnersalesorders/webapp/index.html` | The full **Fiori Elements List Report** with grouping |
| `/$fiori-preview/SalesService/BusinessPartnerSalesOrders` | A quick CAP-generated preview (no manifest config — use the link above instead) |

The List Report opens **already grouped by Company Name and Country**, with
55 rows from the sample dataset (sourced from the provided Excel workbook).
Use the table's settings (⚙ → Group) to change grouping at runtime.

Auth is mocked locally — no login prompt; the in-memory user `alice` has the
required `BPSalesViewer` role.

### Stopping the server

`Ctrl+C` in the terminal.

### Live reload during development

```bash
npx cds watch
```

Restarts the server automatically whenever a `.cds` or service file changes.

---

## Project layout

```
.
├── db/
│   ├── schema.cds                                       # BusinessPartnerSalesOrders entity
│   └── data/iap.sales-BusinessPartnerSalesOrders.csv    # 55 rows from the Excel workbook
├── srv/
│   ├── sales-service.cds                                # OData V4 service @ /sales
│   └── sales-service-ui.cds                             # UI annotations (LineItem, PresentationVariant.GroupBy, ...)
├── app/businesspartnersalesorders/
│   └── webapp/                                          # Fiori Elements List Report
│       ├── manifest.json                                # Responsive table + group personalization on
│       ├── Component.js
│       ├── index.html
│       └── i18n/i18n.properties
└── package.json                                         # CAP root (Node.js)
```

## Where the grouping behavior lives

| File | Annotation / setting | Effect |
| --- | --- | --- |
| `srv/sales-service-ui.cds` | `UI.PresentationVariant.GroupBy: [companyName, country]` | Initial group rows |
| `srv/sales-service-ui.cds` | `UI.PresentationVariant.SortOrder` | Default sort within groups |
| `app/businesspartnersalesorders/webapp/manifest.json` | `tableSettings.personalization.group: true` | Users can change grouping at runtime |
| `app/businesspartnersalesorders/webapp/manifest.json` | `tableSettings.type: "ResponsiveTable"` | Table type that renders group headers |

## Sample data

The CSV in `db/data/` was generated from the supplied
`Business_Partner_Sales_Orders_1.xlsx`. Records use deterministic UUIDs
derived from the row content, so the data survives restarts identically.
The dataset is loaded into an **in-memory SQLite** database on each startup
— no on-disk DB, nothing to reset.

## Deploying to SAP BTP later

Files for Cloud Foundry deployment (`mta.yaml`, `xs-security.json`, the
`approuter/` module) are present in the repo and remain valid, but you do
**not** need them to run locally. They become relevant only when you decide
to deploy. Ignore them for now.
