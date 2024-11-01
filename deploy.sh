#!/bin/bash

HOSTNAME=paffenroth-23.dyn.wpi.edu
USERNAME=student-admin
PORT=22006
KEY=ronak_key

# Add the key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add ronak_key

COMMAND="ssh -i ${KEY} -p ${PORT}  -o StrictHostKeyChecking=no ${USERNAME}@${HOSTNAME}"
ssh -i ${KEY} -p ${PORT} -o BatchMode=yes ${USERNAME}@${HOSTNAME} exit

function setup(){
    rm -rf MultiLingo-AI
    git clone https://github.com/ronak-wani/MultiLingo-AI.git
	cp ./Ronak_Wani_Case_Study_2/.env ./MultiLingo-AI
    cd MultiLingo-AI
		scp -i ronak_key -P ${PORT} -o StrictHostKeyChecking=no main.py index.html requirements.txt .env local_serve.sh ${USERNAME}@${HOSTNAME}:~/
		scp -i ronak_key -P ${PORT} -o StrictHostKeyChecking=no -r static ${USERNAME}@${HOSTNAME}:~/
	${COMMAND} << 'EOF'
			pip install virtualenv
    		virtualenv venv
    		source venv/bin/activate
			if command -v ollama &> /dev/null; then
				echo "Ollama is already installed."
				chmod +x local_serve.sh
				./local_serve.sh
			else
				echo "Ollama is not installed. Installing now..."
				curl -fsSL https://ollama.com/install.sh | sh
				ollama pull mistral
				chmod +x local_serve.sh
				./local_serve.sh
			fi
       		pip install -r requirements.txt
			chmod +x main.py
			nohup ./venv/bin/python3 main.py > log.txt 2>&1 &
EOF
}

if [[ $? -eq 0 ]]
then
        echo "Successful Login"
        ${COMMAND} lsof -i:8000
        if [ $? -eq 0 ]; then
            echo "Port 8000 is in use. Serve is running. No setup"
        else
            echo "Port 8000 is not in use."
            setup	
        fi		
else 
        echo "Unsuccessful Login. Server is not working."
		COMMAND="ssh -i student-admin_key -p ${PORT} ${USERNAME}@${HOSTNAME}"
        scp -i student-admin_key -P ${PORT} -o StrictHostKeyChecking=no ronak_key.pub ${USERNAME}@${HOSTNAME}:~/.ssh/
        ${COMMAND} "cat ~/.ssh/ronak_key.pub > .ssh/authorized_keys"
		chmod 600 .ssh/authorized_keys
		setup
fi