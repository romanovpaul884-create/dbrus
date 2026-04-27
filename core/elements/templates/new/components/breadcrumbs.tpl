{*
    Хлебные крошки для легаси-шаблонов templates/new/.
    Микроразметка Schema.org вынесена в JSON-LD (new_design/seo/schema_breadcrumb.tpl),
    подключаемый через new_design/seo/schema.tpl в meta.tpl. Здесь — только визуальный HTML.
*}
{'!pdoCrumbs' | snippet : [
    'showHome' => 1,
    'tplWrapper' => '@INLINE <div class="breadcrumbs-row"><ul class="breadcrumbs-list">{$output}</ul></div>',
    'tpl' => '@INLINE <li class="breadcrumbs-list__item"><a href="{$link}" class="breadcrumbs-list__link">{$menutitle}</a></li>',
    'tplCurrent' => '@INLINE <li class="breadcrumbs-list__item"><span class="breadcrumbs-list__current">{$menutitle}</span></li>'
]}
