{*
  Schema.org BreadcrumbList.
  Хлебные крошки на основе цепочки родителей текущего ресурса.
  На главной странице (id == site_start) блок не выводится.
*}
{var $resId  = intval($_modx->resource.id)}
{var $homeId = intval($_modx->config['site_start'])}

{if $resId > 0 && $resId != $homeId}
    {var $url = $_modx->config['site_url']}

    {var $items = [[
        'id'   => $homeId,
        'name' => 'Главная'
    ]]}

    {var $parentIds = array_reverse($_modx->getParentIds($resId, 10))}
    {foreach $parentIds as $pid}
        {if intval($pid) > 0 && intval($pid) != $homeId}
            {var $p = $_modx->getObject('modResource', intval($pid))}
            {if $p}
                {set $items[] = [
                    'id'   => intval($pid),
                    'name' => $p.menutitle ?: $p.pagetitle
                ]}
            {/if}
        {/if}
    {/foreach}

    {set $items[] = [
        'id'   => $resId,
        'name' => $_modx->resource.menutitle ?: $_modx->resource.pagetitle
    ]}

    {var $list = []}
    {foreach $items as $i => $item}
        {*
          Для главной (i == 0) URL берём из настройки site_url —
          $_modx->makeUrl(site_start, ..., 'full') в этой версии MODX
          возвращает пустую строку, и Google ругается на missing "item".
          Для остальных пунктов makeUrl работает корректно, но вызываем
          его только когда id заведомо валидный, чтобы не плодить
          PHP-warning «… is not a valid integer …» в error.log.
        *}
        {var $itemUrl = $url}
        {if $i > 0 && intval($item.id) > 0}
            {set $itemUrl = $_modx->makeUrl(intval($item.id), '', '', 'full')}
        {/if}
        {set $list[] = [
            '@type'    => 'ListItem',
            'position' => $i + 1,
            'name'     => $item.name,
            'item'     => $itemUrl
        ]}
    {/foreach}

    {var $pageUrl = $_modx->makeUrl($resId, '', '', 'full')}
    {var $crumb = [
        '@context'        => 'https://schema.org',
        '@type'           => 'BreadcrumbList',
        '@id'             => $pageUrl ~ '#breadcrumb',
        'itemListElement' => $list
    ]}

    <script type="application/ld+json">{$crumb | json_encode : 448}</script>
{/if}
