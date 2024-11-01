const sendButton = document.getElementById("buttonInput");
sendButton.addEventListener('click', async (event) => sendMessage())

async function sendMessage() {
    userText = $('#textInput').val().trim();
    userLanguage = $('#language').find(":selected").val();
    if ($('#localModel').is(":checked")) {
        modelChoice = $('#localModel').val();
    } else {
        modelChoice = "api"
    }
    console.log(userText);
    console.log(userLanguage);
    console.log(modelChoice);
    //userHTML = "<p class='botText'>User: <span>" + userText + "</span></p>";
    //console.log(userHTML);
    console.log(userText);
    if (userText !== "") {
        console.log(userText);
        //$('#js-response-window').append(userHTML);
        //console.log(userHTML);
        await backendResponse();
    }
}

async function backendResponse() {
    console.log("Backend Got User Response: " + userText)
    const obj = {
        input:
            {
                question: userText,
                language: userLanguage
            }
    }
    if (modelChoice === "api") {
        console.log(JSON.stringify(obj.input))
        await fetch("http://localhost:8000/api", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify(obj.input),
        }).then((response) => {
            console.log("Response Status Code" + response.status);
            console.log("Response Status Code" + response);
            if (!response.status) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.json();
        }).then((data) => {
            console.log('Success:', data);
            answer = "<p class='botText'><span>" + data.text + "</span></p>";
            $('#js-response-window').append(answer);
        }).catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
    } else {
        await fetch("http://localhost:8000/chatbot/invoke/", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify(obj),
        }).then((response) => {
            console.log("Response Status Code" + response.status);
            console.log("Response Status Code" + response);
            if (!response.status) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.json();
        }).then((data) => {
            console.log('Success:', data);
            // Handle the response data if needed
            answer = "<p class='botText'><span>" + data.output + "</span></p>";
            $('#js-response-window').append(answer);
        }).catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
    }
}