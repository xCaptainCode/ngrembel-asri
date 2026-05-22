<?php


$router->setDefaults(
    [
        "controller" => "index",
        "action"     => "index",
    ]
);

$router->add("/",
    [
        "controller" => "index",
        "action"     => "index",
    ]
);
$router->add("/fasilitas",
    [
        "controller" => "fasilitas",
        "action"     => "index",
    ]
);
$router->add("/pricelist",
    [
        "controller" => "pricelist",
        "action"     => "index",
    ]
);
$router->add("/wahana/permainan",
    [
        "controller" => "wahana",
        "action"     => "permainan",
    ]
);
$router->add("/wahana/aintball",
    [
        "controller" => "wahana",
        "action"     => "paintball",
    ]
);
$router->add("/wahana/field_trip",
    [
        "controller" => "wahana",
        "action"     => "field_trip",
    ]
);
$router->add("/wahana/fun_game",
    [
        "controller" => "wahana",
        "action"     => "fun_game",
    ]
);
$router->add("/galeri",
    [
        "controller" => "galeri",
        "action"     => "index",
    ]
);
$router->add("/minizoo",
    [
        "controller" => "minizoo",
        "action"     => "index",
    ]
);
$router->add("/kritiksaran",
    [
        "controller" => "kritiksaran",
        "action"     => "index",
    ]
);
$router->add("/settings/:action",
    [
        "controller" => "settings",
        "action"     => 1,
    ]
);

$router->add("/login",
    [
        "controller" => "login",
        "action"     => "index",
    ]
);

$router->add("/registrasi",
    [
        "controller" => "login",
        "action"     => "registrasi",
    ]
);

$router->add("/login/proses",
    [
        "controller" => "login",
        "action"     => "proses",
    ]
);

$router->add("/login/forgot",
    [
        "controller" => "login",
        "action"     => "forgot",
    ]
);

$router->add("/login/logout",
    [
        "controller" => "login",
        "action"     => "logout",
    ]
);

$router->add("/registrasi/proses_registrasi",
    [
        "controller" => "login",
        "action"     => "prosesRegistrasi",
    ]
);

if (isset($_SESSION['id'])) {
    // Logged in ...

	$router->add('/:controller',
		[
			'controller' => 1,
			'action'     => "index"
		]
	);

	$router->add('/:controller/:action/:params',
		[
			'controller' => 1,
			'action'     => 2,
			'params'     => 3,
		]
	);

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
