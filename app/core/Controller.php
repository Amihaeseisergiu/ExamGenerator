<?php

class Controller
{

    public function model($modelName)
    {
        require_once '../app/models/'   .   $modelName . '.php';
        require_once __DIR__ . '../../config/Database.php';

        $database = new Database();
        $db = $database->connect();
        return new $modelName($db);
    }


    public function view($view,$data=[])
    {
        require_once '../app/views/'  .  $view  .   '.php';

    }

}

?>
