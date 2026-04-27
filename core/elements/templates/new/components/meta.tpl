<!DOCTYPE html>
<html lang="{$_modx->config['cultureKey']}">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <base href="{'site_url' | config}">
    <title>{'seoPro.title' | placeholder}</title>
    <meta name="description" content="{$_modx->resource.description}">
    <meta name="keywords" content="{'seoPro.keywords' | placeholder}">
    <meta name="author" content="{'site_name' | option}">
    <meta name="image" content="/assets/images/dist/s_4_col_right_pic.png">
    <meta name="facebook-domain-verification" content="nuiddfmowjw22m97zrwawkgoni9ync" />
    <meta property="og:type" content="website">
    <meta property="og:site_name" content="{'site_name' | option}">
    <meta property="og:title" content="{'seoPro.title' | placeholder}">
    <meta property="og:description" content="{$_modx->resource.description}">
    <meta property="og:image" content="/assets/images/dist/s_4_col_right_pic.png">
    <meta property="og:url" content="{$_modx->config['site_url']}{if $_modx->resource.id != 1}{$_modx->resource.id | url}{/if}">
    <link rel="canonical" href="{$_modx->config['site_url']}{if $_modx->resource.id != 1}{$_modx->resource.id | url}{/if}">
    <link rel="shortcut icon" href="{'favicon' | config}" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="57x57" href="/assets/template/favicon/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="/assets/template/favicon/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/assets/template/favicon/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="/assets/template/favicon/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/assets/template/favicon/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="/assets/template/favicon/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/assets/template/favicon/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/assets/template/favicon/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/assets/template/favicon/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="/assets/template/favicon/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/assets/template/favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="/assets/template/favicon/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/assets/template/favicon/favicon-16x16.png">
    <link rel="manifest" href="/assets/template/favicon/manifest.json">
    <meta name="msapplication-TileImage" content="/assets/template/favicon/ms-icon-144x144.png">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="theme-color" content="#ffffff">
    <meta name="apple-mobile-web-app-title" content="">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta name="format-detection" content="address=no">

    <meta name="zen-verification" content="8b0tftgvPxcjR517KCwTDlO5rjENtCupZohQ7ErtDcTGUkGXk2JbGgd5CVEru5p3" />

    {include 'Victorycorp_script'}
    {*
        <link rel="preload" href="/assets/template/fonts/InterExtraLight/InterExtraLight.woff2" as="font" type="font/woff2" crossorigin>
        <link rel="preload" href="/assets/template/fonts/InterBold/InterBold.woff2" as="font" type="font/woff2" crossorigin>
        <link rel="preload" href="/assets/template/fonts/InterLight/InterLight.woff2" as="font" type="font/woff2" crossorigin>
        <link rel="preload" href="/assets/template/fonts/InterMedium/InterMedium.woff2" as="font" type="font/woff2" crossorigin>
        <link rel="preload" href="/assets/template/fonts/InterSemiBold/InterSemiBold.woff2" as="font" type="font/woff2" crossorigin>
        <link rel="preload" href="/assets/template/fonts/InterRegular/InterRegular.woff2" as="font" type="font/woff2" crossorigin>
    *}
    {* styles -> modifyx *}
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/11.0.5/swiper-bundle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.css">
    <link data-v="cache" rel="stylesheet" href="/assets/template/css/styles.css?v=1811">
    {ignore}
        {$_modx->config['metrika_top']}
    {/ignore}

    {include 'file:new_design/seo/schema.tpl'}
</head>
<body>
