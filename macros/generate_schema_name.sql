{#
    Use the custom schema name verbatim as the BigQuery dataset.

    dbt's default behaviour concatenates the target schema with the custom one
    (e.g. `staging_staging`). For pipeforge we want clean, predictable dataset
    names (`staging`, `intermediate`, `marts`) that match dbt_project.yml and the
    datasets created in BigQuery. When a model defines no `+schema`, fall back to
    the profile's default dataset (`target.schema`).
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema | trim }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
