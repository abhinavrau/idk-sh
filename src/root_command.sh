#inspect_args

querystring=${other_args[*]}


# Read stdin if querystring not provided as arguments
if [[ -z "$querystring" ]]; then
  querystring="$(cat -)"
fi

# Find the shell we are in
shell=$(ps -p "$(ps -p $$ -o ppid=)" -o comm=)

# Get the Linux distro name 
if [ -f /etc/os-release ]; then
    PRETTY_NAME=$(grep -oP 'PRETTY_NAME="\K[^"]+' /etc/os-release)
    os="${PRETTY_NAME}"
else
    os=$(uname -o)
    if [ "$os" = "Darwin" ]; then
        os="macOS"
    fi
fi

# Get the processor architecture
arch=$(uname -m) 

prompt="You are an interactive shell command line shell agent. You just get things done, rather than trying to explain. Do your best to respond with 1 command that will meet the requirements. All other output is just echoed. Favor 1 line shell commands. Be terse. Important: Every command you output will automatically be executed in this environment:"
env_string="{ \'shell\': \'${shell}\',\'operation-system\': \'${os}\',\'architecture\': \'${arch}\' }"
full_payload=$prompt$env_string". Question: "$querystring

jsonPayload="   
{
        \"instances\": [
            {
                \"prefix\": \"${full_payload}\"
            }
        ],
        \"parameters\": {
            \"candidateCount\": 1,
            \"maxOutputTokens\": 1024,
            \"temperature\": 0.2
        }
}"

LOCATION_ID="us-central1"
API_ENDPOINT="${LOCATION_ID}-aiplatform.googleapis.com"
PROJECT_ID="argolis-arau"
MODEL_ID="code-bison"

output=$(curl \
-s \
-X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
"https://${API_ENDPOINT}/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/publishers/google/models/${MODEL_ID}:predict" -d "$jsonPayload" | jq .predictions[0].content)

command=$(echo "$output" | sed 's/"//g')
echo "$command" 






