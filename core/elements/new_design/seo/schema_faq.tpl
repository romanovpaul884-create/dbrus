{*
  Schema.org FAQPage.

  Источник — TV/поле faq_list ресурса (JSON-массив объектов {item_title, item_descr}),
  тот же, что использует new_design/sections/faq.tpl. Если поле пустое или не парсится
  как JSON — блок не выводится. Это позволяет подключать чанк безусловно через
  schema.tpl и автоматически получать разметку на любой странице с FAQ.

  Грабли Fenom учтены:
    - вместо PHP-кастов используется strval();
    - JSON эмитится с флагом 448 (UNESCAPED_UNICODE | UNESCAPED_SLASHES | PRETTY_PRINT),
      чтобы pdoTools-двойной парсинг не принимал { за Fenom-тег.
*}
{var $rawFaq = $_modx->resource.faq_list}
{if $rawFaq}
    {var $questions = json_decode($rawFaq, true)}
    {if $questions && count($questions) > 0}
        {var $entities = []}
        {foreach $questions as $q}
            {if $q.item_title && $q.item_descr}
                {set $entities[] = [
                    '@type'          => 'Question',
                    'name'           => strval($q.item_title),
                    'acceptedAnswer' => [
                        '@type' => 'Answer',
                        'text'  => strval($q.item_descr)
                    ]
                ]}
            {/if}
        {/foreach}

        {if count($entities) > 0}
            {var $homeId = intval($_modx->config['site_start'])}
            {var $pageId = intval($_modx->resource.id)}
            {var $pageUrl = $pageId == $homeId
                ? $_modx->config['site_url']
                : $_modx->makeUrl($pageId, '', '', 'full')}

            {var $faq = [
                '@context'   => 'https://schema.org',
                '@type'      => 'FAQPage',
                '@id'        => $pageUrl ~ '#faq',
                'mainEntity' => $entities
            ]}

            <script type="application/ld+json">{$faq | json_encode : 448}</script>
        {/if}
    {/if}
{/if}
