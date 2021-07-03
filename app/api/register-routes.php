<?php

include_once '../config/Database.php';
include_once '../models/Register.php';
include_once '../config/Response.php';

$database = new Database();
$db = $database->connect();

$register = new Register($db);

$registerRoutes =
    [
        [
            "route" => "register",
            "method" => "POST",
            "handler" => function ($req) {
                global $register;

                $hashedEmail = hash("sha256", $req['payload']['email']);
                $register->insert($req['payload']['email'], $hashedEmail);

                date_default_timezone_set("Europe/Bucharest");
                $serverTime = date('h:i:s');
                $response = array(
                    "hash" => $hashedEmail,
                    "time" => $serverTime
                );

                Response::status(200);
                Response::json($response);
            }
        ]
    ];
