{*
  Schema.org FAQPage.

  Источник — TV/поле faq_list ресурса (JSON-массив объектов {item_title, item_descr}),
  тот же, что использует new_design/sections/faq.tpl. Если поле пустое или не парсится
  как JSON-массив — блок не выводится. Это позволяет подключать чанк безусловно через
  schema.tpl и автоматически получать разметку на любой странице с FAQ.

  Грабли Fenom 2.x учтены:
    - вместо PHP-кастов используется strval();
    - JSON эмитится с флагом 448 (UNESCAPED_UNICODE | UNESCAPED_SLASHES | PRETTY_PRINT),
      чтобы pdoTools-двойной парсинг не принимал структурный { за Fenom-тег;
    - в строковых значениях (заголовки/ответы FAQ) литералы { } могут встретиться
      внутри HTML/JS — PRETTY_PRINT их НЕ разряжает. Поэтому до json_encode заменяем
      { → __JSON_LB__, } → __JSON_RB__, а после json_encode маркеры → { / }
      (unicode-эскейпы). JSON-парсеры декодируют обратно, а Fenom при втором проходе
      литеральной { уже не видит. Та же логика, что в schema_website.tpl.
    - makeUrl с пустым resource.id (404 / служебные ресурсы) даёт PHP-warning,
      поэтому вызываем makeUrl только при $pageId > 0.
*}
{var $rawFaq = $_modx->resource.faq_list}
{if $rawFaq}
    {var $questions = json_decode($rawFaq, true)}
    {if is_array($questions) && count($questions) > 0}
        {var $LB    = chr(123)}
        {var $RB    = chr(125)}
        {var $LBesc = chr(92) ~ 'u007B'}
        {var $RBesc = chr(92) ~ 'u007D'}

        {var $entities = []}
        {foreach $questions as $q}
            {if $q.item_title && $q.item_descr}
                {var $title = str_replace([$LB, $RB], ['__JSON_LB__', '__JSON_RB__'], strval($q.item_title))}
                {var $text  = str_replace([$LB, $RB], ['__JSON_LB__', '__JSON_RB__'], strval($q.item_descr))}
                {set $entities[] = [
                    '@type'          => 'Question',
                    'name'           => $title,
                    'acceptedAnswer' => [
                        '@type' => 'Answer',
                        'text'  => $text
                    ]
                ]}
            {/if}
        {/foreach}

        {if count($entities) > 0}
            {var $homeId = intval($_modx->config['site_start'])}
            {var $pageId = intval($_modx->resource.id)}
            {var $pageUrl = ''}
            {if $pageId == $homeId}
                {set $pageUrl = $_modx->config['site_url']}
            {elseif $pageId > 0}
                {set $pageUrl = $_modx->makeUrl($pageId, '', '', 'full')}
            {/if}

            {var $faq = [
                '@context'   => 'https://schema.org',
                '@type'      => 'FAQPage',
                '@id'        => $pageUrl ~ '#faq',
                'mainEntity' => $entities
            ]}

            {var $json = $faq | json_encode : 448}
            {set $json = str_replace(['__JSON_LB__', '__JSON_RB__'], [$LBesc, $RBesc], $json)}
            <script type="application/ld+json">{$json}</script>
        {/if}
    {/if}
{/if}
