{*
  Schema.org BreadcrumbList.
  Хлебные крошки на основе цепочки родителей текущего ресурса.
  На главной странице (id == site_start) блок не выводится.
*}
{if $_modx->resource.id != $_modx->config['site_start']}
    {var $url = $_modx->config['site_url']}
    {var $homeId = intval($_modx->config['site_start'])}

    {var $items = [[
        'id'   => $homeId,
        'name' => 'Главная'
    ]]}

    {var $parentIds = array_reverse($_modx->getParentIds($_modx->resource.id, 10))}
    {foreach $parentIds as $pid}
        {if $pid && $pid != $homeId}
            {var $p = $_modx->getObject('modResource', $pid)}
            {if $p}
                {set $items[] = [
                    'id'   => $pid,
                    'name' => $p.menutitle ?: $p.pagetitle
                ]}
            {/if}
        {/if}
    {/foreach}

    {set $items[] = [
        'id'   => $_modx->resource.id,
        'name' => $_modx->resource.menutitle ?: $_modx->resource.pagetitle
    ]}

    {var $list = []}
    {foreach $items as $i => $item}
        {*
          Для главной (i == 0) URL берём из настройки site_url —
          $_modx->makeUrl(site_start, ..., 'full') в этой версии MODX
          возвращает пустую строку, и Google ругается на missing "item".
          Для остальных пунктов makeUrl работает корректно.
        *}
        {var $itemUrl = $i == 0 ? $url : $_modx->makeUrl($item.id, '', '', 'full')}
        {set $list[] = [
            '@type'    => 'ListItem',
            'position' => $i + 1,
            'name'     => $item.name,
            'item'     => $itemUrl
        ]}
    {/foreach}

    {var $crumb = [
        '@context'        => 'https://schema.org',
        '@type'           => 'BreadcrumbList',
        '@id'             => $_modx->makeUrl($_modx->resource.id, '', '', 'full') ~ '#breadcrumb',
        'itemListElement' => $list
    ]}

    <script type="application/ld+json">{$crumb | json_encode : 448}</script>
{/if}
