function _ssm_complete
    aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' --output json |\
        jq -r '.Reservations[].Instances[] | .InstanceId + "\t" + ([.Tags[] | select(.Key == "Name")][0].Value // "-") + ", " + .PrivateIpAddress'
end

complete -c ssm -f -a '(_ssm_complete)'
