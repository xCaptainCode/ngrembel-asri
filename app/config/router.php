<?php
define('LEVEL', isset($_SESSION['role']) ? $_SESSION['role'] : null);


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
$router->add("/menu",
    [
        "controller" => "menu",
        "action"     => "index",
    ]
);
$router->add("/wahana",
    [
        "controller" => "wahana",
        "action"     => "index",
    ]
);
$router->add("/kritiksaran",
    [
        "controller" => "kritiksaran",
        "action"     => "index",
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

if (isset($_SESSION['username'])) {
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
