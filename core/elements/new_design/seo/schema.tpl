{*
  SEO-оркестратор: подключается ОДИН раз перед </head> в meta.tpl:

      {include 'file:new_design/seo/schema.tpl'}

  Сам выбирает, какие schema.org-блоки выводить:
    - Общесайтовые (Organization + WebSite + Breadcrumb) — ВСЕГДА.
    - Контекстный блок — по TV resource_schema_type (article|house|none),
      либо по системной настройке dbrus_schema_template_map
      (карта "id_шаблона:тип" через запятую, например "5:article,7:house").
*}
{var $r = $_modx->resource}

{* 1. Общесайтовые блоки — на каждой странице *}
{include 'file:new_design/seo/schema_organization.tpl'}
{include 'file:new_design/seo/schema_website.tpl'}
{include 'file:new_design/seo/schema_breadcrumb.tpl'}

{* 2. Определяем тип страницы *}
{var $type = $r.resource_schema_type}

{if !$type}
    {var $map = $_modx->config['dbrus_schema_template_map']}
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
        {include 'file:new_design/seo/schema_article.tpl'}
    {case 'house'}
        {include 'file:new_design/seo/schema_house.tpl'}
    {case 'none'}
        {* блок отключён вручную *}
{/switch}
