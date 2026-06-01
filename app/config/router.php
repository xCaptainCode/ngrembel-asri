<?php

$router->setDefaults([
    "controller" => "index",
    "action"     => "index",
]);

$router->add("/", [
    "controller" => "index",
    "action"     => "index",
]);

$router->add("/fasilitas", [
    "controller" => "fasilitas", 
    "action"     => "index",
]);

$router->add("/price-list", [
    "controller" => "pricelist", 
    "action"     => "index",
]);

$router->add("/wahana-permainan", [
    "controller" => "wahana", 
    "action"     => "permainan",
]);

$router->add("/wahana-paintball", [
    "controller" => "wahana", 
    "action"     => "paintball",
]);

$router->add("/wahana-field-trip", [
    "controller" => "wahana", 
    "action"     => "field_trip",
]);

$router->add("/wahana-fun-game", [
    "controller" => "wahana", 
    "action"     => "fun_game",
]);

// Gallery - Public
$router->addGet('/galeri', [
    'controller' => 'Gallery',
    'action'     => 'index',
]);
$router->addGet('/galeri/detail/([a-zA-Z0-9\-]+)', [
    'controller' => 'Gallery',
    'action'     => 'detail',
    'id'         => 1,
]);
$router->addGet('/galeri/download/([a-zA-Z0-9\-]+)', [
    'controller' => 'Gallery',
    'action'     => 'download',
    'id'         => 1,
]);

// Gallery - Upload (hanya admin, lindungi dengan middleware/auth check di controller)
$router->addGet('/galeri/upload', [
    'controller' => 'Gallery',
    'action'     => 'uploadForm',
]);
$router->addPost('/galeri/upload', [
    'controller' => 'Gallery',
    'action'     => 'uploadProcess',
]);
$router->addGet('/settings/edit_galeri/([a-zA-Z0-9\-]+)', [
    'controller' => 'Settings',
    'action'     => 'edit_galeri',
    'id'         => 1,
]);
$router->addPost('/settings/update_galeri/([a-zA-Z0-9\-]+)', [
    'controller' => 'Settings',
    'action'     => 'update_galeri',
    'params'     => 1,
]);

$router->add("/mini-zoo", [
    "controller" => "minizoo", 
    "action"     => "index",
]);

$router->add("/kritik-saran", [
    "controller" => "kritiksaran", 
    "action"     => "index",
]);

$router->add("/kritik-saran",[
    "controller" => "kritiksaran",
    "action"     => "index",
]);

$router->add("/kritik-saran/load-more", [
    "controller" => "kritiksaran",
    "action"     => "loadMore",
]);

$router->add("/login",[
    "controller" => "login",
    "action"     => "index",
]);

$router->add("/registrasi",[
    "controller" => "login",
    "action"     => "registrasi",
]);

$router->add("/login/proses",[
    "controller" => "login",
    "action"     => "proses",
]);

$router->add("/login/forgot",[
    "controller" => "login",
    "action"     => "forgot",
]);

$router->addGet("/lupa-password", [
    "controller" => "login",
    "action"     => "forgot",
]);

$router->addPost("/lupa-password", [
    "controller" => "login",
    "action"     => "kirimLink",
]);

$router->addGet("/reset-password", [
    "controller" => "login",
    "action"     => "tampilkanForm",
]);

$router->addPost("/reset-password", [
    "controller" => "login",
    "action"     => "prosesReset",
]);

$router->add("/login/logout",[
    "controller" => "login",
    "action"     => "logout",
]);

$router->add("/registrasi/proses_registrasi",[
    "controller" => "login",
    "action"     => "prosesRegistrasi",
]);


if (isset($_SESSION['id'])) {
    // Logged in ...

    // $router->add('/:controller',
    // 	[
    // 		'controller' => 1,
    // 		'action'     => "index"
    // 	]
    // );

    // $router->add('/:controller/:action/:params',
    // 	[
    // 		'controller' => 1,
    // 		'action'     => 2,
    // 		'params'     => 3,
    // 	]
    // );

    $router->add("/fasilitas",[
        "controller" => "fasilitas", 
        "action"     => "index",
    ]);

    $router->add("/price-list",[
        "controller" => "pricelist", 
        "action"     => "index",
    ]);

    $router->add("/wahana-permainan",[
        "controller" => "wahana", 
        "action"     => "permainan",
    ]);

    $router->add("/wahana-paintball",[
        "controller" => "wahana", 
        "action"     => "paintball",
    ]);

    $router->add("/wahana-field-trip",[
        "controller" => "wahana", 
        "action"     => "field_trip",
    ]);

    $router->add("/wahana-fun-game",[
        "controller" => "wahana", 
        "action"     => "fun_game",
    ]);

    $router->add("/galeri",[
        "controller" => "Gallery", 
        "action"     => "index",
    ]);

    $router->add("/mini-zoo",[
        "controller" => "minizoo", 
        "action"     => "index",
    ]);

    $router->add("/kritik-saran",[
        "controller" => "kritiksaran", 
        "action"     => "index",
    ]);

    $router->add("/kritik-saran/load-more",[
        "controller" => "kritiksaran", 
        "action"     => "loadMore",
    ]);

    $router->add("/settings/:action",[
        "controller" => "settings", 
        "action"     => 1,
    ]);

    $router->add("/registrasi",[
        "controller" => "login", 
        "action"     => "registrasi",
    ]);

    $router->add("/login",[
        "controller" => "login", 
        "action"     => "index",
    ]);
    
    $router->add("/login/proses",[
        "controller" => "login", 
        "action"     => "proses",
    ]);

    $router->add("/login/forgot",[
        "controller" => "login", 
        "action"     => "forgot",
    ]);

    $router->addGet("/lupa-password", [
        "controller" => "login",
        "action"     => "forgot",
    ]);

    $router->addPost("/lupa-password", [
        "controller" => "login",
        "action"     => "kirimLink",
    ]);

    $router->addGet("/reset-password", [
        "controller" => "login",
        "action"     => "tampilkanForm",
    ]);

    $router->addPost("/reset-password", [
        "controller" => "login",
        "action"     => "prosesReset",
    ]);

    $router->add("/login/logout",[
        "controller" => "login", 
        "action"     => "logout",
    ]);

    $router->add("/registrasi/proses_registrasi",[
        "controller" => "login", 
        "action"     => "prosesRegistrasi",
    ]);

    $router->add("/member-point",[
        "controller" => "member", 
        "action"     => "point",
    ]);

    $router->add("/member-history",[
        "controller" => "member", 
        "action"     => "history",
    ]);

    $router->add("/member-profile",[
        "controller" => "member", 
        "action"     => "profile",
    ]);

} else {
    // Not logged in.
    // The defaults already point to index/index
}
return $router;

/* Redirect juga bisa dengan Dispatcher pada Controller 
https://www.tutorialspoint.com/phalcon/phalcon_security_features.htm

return $this->dispatcher->forward(array( 
    'controller' => 'posts', 
    'action' => 'index' 
)); 
*/
