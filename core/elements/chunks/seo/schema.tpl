{*
  SEO-оркестратор: подключается ОДИН раз перед </head> в базовом шаблоне.

      <head>
          ...
          {include 'seo/schema'}
      </head>

  Сам выбирает, какие schema.org-блоки выводить, на основе:
    - системной настройки dbrus_schema_template_map (опц.) — карта
      "id_шаблона:тип" через запятую, например: "5:article,7:house,8:house"
    - либо TV resource_schema_type на ресурсе (article|house|none)

  Базовые блоки (Organization + WebSite + Breadcrumb) выводятся всегда.
*}
{var $r = $_modx->resource}

{* 1. Общесайтовые блоки — на каждой странице *}
{include 'seo/schema_organization'}
{include 'seo/schema_website'}
{include 'seo/schema_breadcrumb'}

{* 2. Контекстный блок: определяем тип контента *}
{var $type = $r.getTVValue('resource_schema_type')}

{if !$type}
    {var $map = $_modx->config.dbrus_schema_template_map}
    {if $map}
        {foreach explode(',', $map) as $pair}
            {var $kv = explode(':', trim($pair))}
            {if (int)$kv.0 == (int)$r.template && $kv.1}
                {set $type = trim($kv.1)}
                {break}
            {/if}
        {/foreach}
    {/if}
{/if}

{switch $type}
    {case 'article'}
        {include 'seo/schema_article'}
    {case 'house'}
        {include 'seo/schema_house'}
    {case 'none'}
        {* блок отключён вручную *}
{/switch}
