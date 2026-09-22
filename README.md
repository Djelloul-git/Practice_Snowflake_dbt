# 🚀 Telecom Analytics Platform — dbt + Snowflake

> Mini projet complet de **Modern Data Stack** simulant une plateforme analytique telecom,
> couvrant l'ensemble des concepts dbt Core et Snowflake pour une certification **SnowPro Core**.

---

## 📐 Architecture

```
TELECOM_DB_DEV / TELECOM_DB_PROD
├── DATA_RAW        ← Données brutes chargées via COPY INTO
├── DATA_STAGING    ← Modèles dbt : stg_* et int_*
├── DATA_MARTS      ← Tables analytiques finales
└── SNAPSHOTS       ← Historisation SCD Type 2
```

**Stack technique**
- **Snowflake** — Data Warehouse cloud
- **dbt Core 1.12** — Transformation & documentation
- **Python + Faker** — Génération du jeu de données
- **UV** — Gestion des packages Python
- **VS Code** — Environnement de développement

---

## 📊 Jeu de données

Dataset telecom synthétique généré avec Faker — 18 mois de données (Jan 2023 → Juin 2024)

| Table | Lignes | Description |
|---|---|---|
| `customers` | 2 000 | Clients, offres, régions, churn (19%) |
| `invoices` | 1 991 | Factures mensuelles, remises, retards |
| `usage` | 1 991 | Consommation data/voix/SMS |
| `incidents` | 312 | Tickets SAV, SLA breach, NPS |
| `offer_changes` | 484 | Changements d'offre → SCD Type 2 |
| `offers_seed` | 5 | Référentiel offres (dbt seed) |

**Offres disponibles**

| Code | Data | Prix | Segment |
|---|---|---|---|
| STARTER_5G | 20 Go | 14,99 € | low |
| SMART_5G | 60 Go | 24,99 € | mid |
| POWER_5G | 120 Go | 34,99 € | mid |
| ELITE_5G | Illimité | 44,99 € | high |
| PRO_BUSINESS | Illimité | 59,99 € | business |

---

## 🏗️ Structure du projet

```
telecom_dbt/
├── models/
│   ├── staging/
│   │   ├── sources.yml                    # Déclaration sources RAW
│   │   ├── schema.yml                     # Tests & documentation
│   │   ├── stg_customers.sql              # Clients nettoyés
│   │   ├── stg_invoices.sql               # Factures nettoyées
│   │   ├── stg_usage.sql                  # Usage nettoyé
│   │   ├── stg_incidents.sql              # Incidents nettoyés
│   │   ├── stg_offer_changes.sql          # Changements d'offre
│   │   ├── int_customers.sql              # Clients + churn flag + overage
│   │   ├── int_incidents.sql              # Incidents + SLA calculé
│   │   ├── int_customers_invoices.sql     # Agrégation mensuelle clients/factures
│   │   ├── int_customers_usage.sql        # Usage rolling 3 mois
│   │   ├── int_churn_signals.sql          # Score de churn composite
│   │   └── int_invoices_incremental.sql   # Factures en mode incrémental
│   └── marts/
│       ├── mart_customer_360.sql          # Vue synthétique 1 ligne/client
│       ├── mart_customer_monthly.sql      # Vue mensuelle client
│       ├── mart_revenue.sql               # Revenue MoM + YTD
│       ├── mart_churn.sql                 # Taux de churn + durée avant churn
│       └── mart_usage_quality.sql         # Qualité service + SLA breach
├── snapshots/
│   └── snap_customers.sql                 # SCD Type 2 sur offer_code/segment
├── seeds/
│   └── offers_seed_dbt.csv               # Référentiel offres statique
├── macros/
│   ├── is_churned.sql                     # Macro churn (N mois sans facture)
│   ├── overage_rate.sql                   # Macro taux dépassement forfait
│   ├── sla_status.sql                     # Macro statut SLA (OK/BREACH)
│   └── generate_schema_name.sql           # Override routing schéma dbt
├── tests/
│   ├── assert_churn_date_after_subscription.sql
│   ├── assert_closed_after_opened.sql
│   ├── assert_invoice_amount_positive.sql
│   └── assert_no_future_dates.sql
├── dbt_project.yml
└── README.md
```

---

## 🎯 Use Cases implémentés

### Snowflake

| # | Use Case | Concepts |
|---|---|---|
| UC-01 | Architecture & RBAC | Databases, Schemas, Virtual Warehouses, Roles, GRANT |
| UC-02 | Stages & COPY INTO | Internal Stage, File Format, VALIDATION_MODE, ON_ERROR |
| UC-03 | Zero-copy Cloning | CLONE Schema, isolation DEV/PROD |
| UC-17 | Time Travel | AT(OFFSET), CLONE dans le passé, restauration |
| UC-18 | Streams & Tasks | CDC, MERGE, METADATA$ACTION, METADATA$ISUPDATE |
| UC-19 | EXECUTE IMMEDIATE | Procédure stockée, SQL dynamique |
| UC-20 | Query Profile | TableScan, Spillage, Clustering, Result Cache |

### dbt Core

| # | Use Case | Concepts |
|---|---|---|
| UC-04 | Sources & Freshness | sources.yml, warn_after, error_after |
| UC-05 | Modèles Staging | Cast types, renommage, TO_DATE, TO_TIMESTAMP |
| UC-06 | Tests Génériques | unique, not_null, accepted_values |
| UC-07 | Tests Singuliers | Logique métier SQL, validation temporelle |
| UC-08 | Seeds | Référentiel statique CSV |
| UC-09 | Macros Jinja | Fonctions réutilisables, IFF Snowflake |
| UC-10 | Modèle Incrémental | merge strategy, is_incremental(), unique_key |
| UC-11 | Snapshot SCD Type 2 | dbt_valid_from, dbt_valid_to, check_cols |
| UC-12 | Intermediate | Window functions, LAG, rolling 3 mois |
| UC-13 | mart_customer_360 | Vue synthétique 1 ligne/client |
| UC-14 | mart_revenue | MoM avec LAG(), YTD avec SUM OVER |
| UC-15 | mart_churn | Taux churn, durée avant churn par offre |
| UC-16 | mart_usage_quality | SLA breach rate, NPS par canal |
| UC-21 | dbt Docs | Lineage graph, documentation colonnes |

---

## 📈 Lineage Graph

[![Lineage Graph](docs/lineage_graph.png)](https://github.com/Djelloul-git/Practice_Snowflake_dbt/blob/main/Lineage%20Graph.JPG)

> De gauche à droite : Sources RAW → Staging → Intermediate → Marts

---

## ⚡ Installation & Lancement

### Prérequis
- Python 3.11+
- UV installé
- Compte Snowflake actif

### Setup

```bash
# Cloner le repo
git clone https://github.com/Djelloul-git/telecom-analytics-dbt-snowflake
cd telecom-analytics-dbt-snowflake

# Créer l'environnement virtuel
uv venv --python 3.11
uv add dbt-snowflake

# Configurer la connexion Snowflake
# Créer ~/.dbt/profiles.yml avec vos credentials
```

### Générer le jeu de données

```bash
pip install faker pandas
python data/generate_telecom_data.py
```

### Setup Snowflake

Exécuter dans l'ordre dans Snowflake :
1. `snowflake/Script_Creates_Objects.sql` — bases, schémas, warehouses, RBAC
2. `snowflake/Staging.sql` — création des stages
3. `snowflake/Copy_Data_From_Stage_*.sql` — chargement des données

### Lancer dbt

```bash
# Vérifier la connexion
uv run dbt debug

# Charger les seeds
uv run dbt seed

# Lancer tous les modèles
uv run dbt run

# Lancer les tests
uv run dbt test

# Générer la documentation
uv run dbt docs generate
uv run dbt docs serve
```

---

## 🗂️ Commandes utiles

```bash
# Cibler un modèle spécifique
uv run dbt run -s mart_customer_360

# Cibler une chaîne complète (upstream)
uv run dbt run -s +mart_customer_360

# Lancer uniquement les tests singuliers
uv run dbt test --select test_type:singular

# Forcer un full refresh sur un modèle incrémental
uv run dbt run -s int_invoices_incremental --full-refresh

# Lancer le snapshot
uv run dbt snapshot -s snap_customers

# Vérifier la fraîcheur des sources
uv run dbt source freshness
```

---

## 🔐 RBAC Snowflake

| Rôle | Accès | Warehouse |
|---|---|---|
| `ROLE_DBT_DEV` | READ sur RAW, CREATE sur STAGING/MARTS DEV | WH_LOADING + WH_TRANSFORMING |
| `ROLE_DBT_PROD` | READ sur RAW, CREATE sur STAGING/MARTS PROD | WH_TRANSFORMING |
| `ROLE_ANALYST` | SELECT sur DATA_MARTS PROD uniquement | WH_ANALYST |

---

## 📝 Contexte

Ce projet simule une migration de logique métier **Oracle PL/SQL → dbt + Snowflake**,
ancré dans un contexte telecom réel (facturation, consommation, incidents SAV).

Il couvre l'essentiel du programme de certification **Snowflake SnowPro Core (COF-C02)**
et démontre les compétences d'un profil **Analytics Engineer** sur la modern data stack.

---

## 👤 Auteur

**Djelloul Ouzaich** — Analytics Engineer & AI Agents  
[LinkedIn](https://linkedin.com/in/ouzaich-djelloul-46a75223) · [GitHub](https://github.com/Djelloul-git)

*OZDATA Consulting — Achères, Île-de-France*
