<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Taker</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>

    <link href="../css/index.css" rel="stylesheet">
</head>

<body>
    <nav class="navbar navbar-light justify-content-center align-items-center" style="background-color: #3399ff;">
        <a class="navbar-brand text-white" href="#">Test Taker</a>
    </nav>

    <div class="container d-flex justify-content-center align-items-center" style="height:90%" id="registerContainer">

        <div class="row">

            <form class="form-signin" id="registerForm">

                <div class="text-center shadow p-3 bg-white rounded">
                    <h1 class="h5 mb-3 font-weight-normal shadow-sm p-3 bg-white rounded">Please enter your email address</h1>
                    <label for="inputEmail" class="sr-only">Email address</label>
                    <input type="email" id="inputEmail" class="form-control" placeholder="Email address" required autofocus>
                    <button class="btn btn-lg btn-primary btn-block mt-2" type="submit" id="registerBtn">Register</button>
                </div>
            </form>
        </div>
    </div>

    <div class="container" style="height:90%" id="questionContainer">
        <div class="row align-items-center h-100">
            <div class="col-8 mx-auto">
                <div class="container shadow p-3 bg-white rounded">
                    <div class="card bg-light mb-3">
                        <div class="card-header">Question:</div>
                        <div class="card-body">
                            <h5 class="card-title" id="questionText">Replace</h5>
                        </div>
                    </div>
                    <div class="btn-group-vertical" style="width: 100%" data-toggle="buttons">
                        <label class="btn btn-light responsive-btn" id="response1">
                            Replace
                            <input type="checkbox" style="display:none;" name="checked_1" id="checked1" value="Checked 1">
                        </label>
                        <label class="btn btn-light responsive-btn" id="response2">
                            Replace
                            <input type="checkbox" style="display:none;" name="checked_2" id="checked2" value="Checked 2">
                        </label>
                        <label class="btn btn-light responsive-btn" id="response3">
                            Replace
                            <input type="checkbox" style="display:none;" name="checked_3" id="checked3" value="Checked 3">
                        </label>
                        <label class="btn btn-light responsive-btn" id="response4">
                            Replace
                            <input type="checkbox" style="display:none;" name="checked_4" id="checked4" value="Checked 4">
                        </label>
                        <label class="btn btn-light responsive-btn" id="response5">
                            Replace
                            <input type="checkbox" style="display:none;" name="checked_5" id="checked5" value="Checked 5">
                        </label>
                        <label class="btn btn-light responsive-btn" id="response6">
                            Replace
                            <input type="checkbox" style="display:none;" name="checked_6" id="checked6" value="Checked 6">
                        </label>
                    </div>
                    <div class="row justify-content-center">
                        <button class="btn btn-success responsive-btn mt-3" style="width:97%" onclick="submitQuestion()">Submit</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container" id="scoreContainer">
        <div class="row align-items-center mt-4">
            <div class="col-8 mx-auto">
                <div class="container shadow p-3 bg-white rounded">
                    <div class="card bg-light mb-3">
                        <div class="card-header">Last test score:</div>
                        <div class="card-body">
                            <h5 class="card-title" id="scoreText">Replace</h5>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <button class="btn btn-success responsive-btn mt-3" style="width:97%" onclick="startNewTest()">Start new test</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container" id="previousTestContainer">
        <div class="row align-items-center mt-4 mb-4">
            <div class="col-8 mx-auto">
                <div class="container shadow p-3 bg-white rounded" id="insertPreviousTest">
                </div>
            </div>
        </div>
    </div>

    <script>
        //window.localStorage.clear();

        var currentQuestionData = null;
        var scoreDOM = document.getElementById("scoreContainer").parentElement.removeChild(document.getElementById("scoreContainer"));
        var previousTestDOM = document.getElementById("previousTestContainer").parentElement.removeChild(document.getElementById("previousTestContainer"));
        var questionDOM = document.getElementById("questionContainer");
        if (window.localStorage.getItem("email") == null && window.localStorage.getItem("hash") == null) {

            let parent = document.getElementById("questionContainer").parentElement;
            let child = parent.removeChild(document.getElementById("questionContainer"));
            document.getElementById("registerForm").addEventListener("submit", function(e) {
                let email = document.getElementById("inputEmail").value;
                fetch('http://localhost:80/sgbd/proiect/public/api/register', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            "email": email
                        }),
                    })
                    .then(response => response.json())
                    .then(data => {
                        window.localStorage.setItem("email", email);
                        window.localStorage.setItem("hash", data.hash);
                        document.getElementById("registerContainer").parentElement.removeChild(document.getElementById("registerContainer"));

                        fetch('http://localhost:80/sgbd/proiect/public/api/question', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify({
                                    "email": email,
                                    "hash": data.hash
                                }),
                            })
                            .then(response => response.json())
                            .then(data => {
                                if(data.Score == null) updateQuestion(parent, child, data, false);
                                else showLastScore(parent, child, data, false);
                            });
                    });
                e.preventDefault();
            });
        } else {
            document.getElementById("registerContainer").parentElement.removeChild(document.getElementById("registerContainer"));
            let parent = document.getElementById("questionContainer").parentElement;
            let child = parent.removeChild(document.getElementById("questionContainer"));
            
            fetch('http://localhost:80/sgbd/proiect/public/api/question', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        "email": window.localStorage.getItem("email"),
                        "hash": window.localStorage.getItem("hash"),
                        "response": "a:a"
                    }),
                })
                .then(response => response.json())
                .then(data => {
                    if(data.Score == null) updateQuestion(parent, child, data, false);
                    else showLastScore(parent, child, data, false);
                });
        }

        function updateQuestion(parent, child, data, update)
        {
            currentQuestionData = [
                {"intrebare": data.intrebare, "id_intrebare": data.id_intrebare},
                {"raspuns": data.raspuns_1, "id_raspuns": data.id_rasp_1},
                {"raspuns": data.raspuns_2, "id_raspuns": data.id_rasp_2},
                {"raspuns": data.raspuns_3, "id_raspuns": data.id_rasp_3},
                {"raspuns": data.raspuns_4, "id_raspuns": data.id_rasp_4},
                {"raspuns": data.raspuns_5, "id_raspuns": data.id_rasp_5},
                {"raspuns": data.raspuns_6, "id_raspuns": data.id_rasp_6}
            ];

            if(!update) parent.appendChild(child);
            document.getElementById("questionText").innerText = currentQuestionData[0].intrebare;

            for(var i = 1; i < 7; i++)
            {
                var responseLabel = document.getElementById("response" + i);
                var text_to_change = responseLabel.childNodes[0];
                text_to_change.nodeValue = currentQuestionData[i].raspuns;
            }
        }

        function showLastScore(parent, child, data, remove)
        {
            if(remove)
            {
                parent.removeChild(child);
            }

            parent.appendChild(scoreDOM);
            parent.appendChild(previousTestDOM);
            document.getElementById("scoreText").innerText = data.Score.Total;
            document.getElementById("insertPreviousTest").innerHTML = "";
            for(var i = 0; i < data.questions.length; i++)
            {
                document.getElementById("insertPreviousTest").innerHTML = document.getElementById("insertPreviousTest").innerHTML +
                    "<div class=\"card bg-light mb-3\">" +
                        "<div class=\"card-header\">" + data.questions[i].intrebare + "</div>" +
                        "<div class=\"card-body\" id=\"insertQuestions" + i + "\">" +
                        "</div>" +
                    "</div>";

                for(var j = 0; j < data.questions[i].raspunsuri.length; j++)
                {
                    if(data.questions[i].raspunsuri[j].type === "hit")
                    {
                        document.getElementById("insertQuestions" + i).innerHTML = document.getElementById("insertQuestions" + i).innerHTML +
                            "<div class=\"card text-white bg-success mb-2\">" +
                                "<div class=\"card-header responsive-badge\">" + 
                                    "<div>" + data.questions[i].raspunsuri[j].raspuns + 
                                    "</div>" + "<span class=\"badge badge-light\">" + data.questions[i].raspunsuri[j].points + "</span>" + 
                                "</div>" +
                            "</div>";
                    }
                    else if(data.questions[i].raspunsuri[j].type === "miss")
                    {
                        document.getElementById("insertQuestions" + i).innerHTML = document.getElementById("insertQuestions" + i).innerHTML +
                            "<div class=\"card text-white bg-danger mb-2\">" +
                                "<div class=\"card-header responsive-badge\">" + 
                                    "<div>" + data.questions[i].raspunsuri[j].raspuns + 
                                    "</div>" + "<span class=\"badge badge-light\">" + data.questions[i].raspunsuri[j].points + "</span>" + 
                                "</div>" +
                            "</div>";
                    }
                    else if(data.questions[i].raspunsuri[j].type === "correct")
                    {
                        document.getElementById("insertQuestions" + i).innerHTML = document.getElementById("insertQuestions" + i).innerHTML +
                            "<div class=\"card border-success mb-2\">" +
                                "<div class=\"card-header\">" + data.questions[i].raspunsuri[j].raspuns + "</div>" +
                            "</div>";
                    }
                    else if(data.questions[i].raspunsuri[j].type === "incorrect")
                    {
                        document.getElementById("insertQuestions" + i).innerHTML = document.getElementById("insertQuestions" + i).innerHTML +
                            "<div class=\"card border-danger mb-2\">" +
                                "<div class=\"card-header\">" + data.questions[i].raspunsuri[j].raspuns + "</div>" +
                            "</div>";
                    }
                }
            }
        }

        function submitQuestion()
        {
            var csv = currentQuestionData[0].id_intrebare + ":";
            var first = true;
            for(var i = 1; i <=6; i++)
            {
                if(document.getElementById("checked" + i).checked)
                {
                    if(first)
                    {
                        csv = csv + currentQuestionData[i].id_raspuns;
                        first = false;
                    }
                    else csv = csv + "," + currentQuestionData[i].id_raspuns;

                    document.getElementById("checked" + i).click();
                }
            }
            if(first) csv = null;
            let parent = document.getElementById("questionContainer").parentElement;
            let child = document.getElementById("questionContainer");
            
            fetch('http://localhost:80/sgbd/proiect/public/api/question', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        "email": window.localStorage.getItem("email"),
                        "hash": window.localStorage.getItem("hash"),
                        "response": csv
                    }),
                })
                .then(response => response.json())
                .then(data => {
                    if(data.Score == null) updateQuestion(parent, child, data, true);
                    else showLastScore(parent, child, data, true);
                });
        }

        function startNewTest()
        {
            let parent = scoreDOM.parentElement;
            let child = parent.removeChild(scoreDOM);
            child = parent.removeChild(previousTestDOM);
            child = questionDOM;
            
            fetch('http://localhost:80/sgbd/proiect/public/api/question', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        "email": window.localStorage.getItem("email"),
                        "hash": window.localStorage.getItem("hash"),
                    }),
                })
                .then(response => response.json())
                .then(data => {
                    updateQuestion(parent, child, data, false);
                });
        }
    </script>
</body>

</html>