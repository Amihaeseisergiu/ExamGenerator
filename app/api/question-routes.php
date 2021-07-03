<?php

include_once '../config/Database.php';
include_once '../models/Question.php';
include_once '../config/Response.php';

$database = new Database();
$db = $database->connect();

$question = new Question($db);

$questionRoutes =
    [
        [
            "route" => "question",
            "method" => "POST",
            "handler" => function ($req) {
                global $question;

                if(!isset($req['payload']['response']))
                    $req['payload']['response'] = null;

                $exists = $question->verifyExistence($req['payload']['email'], $req['payload']['hash']);

                if($exists)
                {
                    $json = $question->callUrmatoareaIntrebare($req['payload']['email'], $req['payload']['response']);
                    Response::status(200);
                    Response::json($json);
                }
                else
                {
                    Response::status(200);
                    Response::text("Email and hash don't exist in the database");
                }
            }
        ]
    ];