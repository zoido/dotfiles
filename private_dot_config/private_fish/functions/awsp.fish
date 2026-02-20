function awsp --description 'Select AWS profile with fzf'
    set -l profile (sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)
    if test -n "$profile"
        eval (AWS_PROFILE=$profile aws configure export-credentials --format env --profile "$profile")
        set -gx AWS_PROFILE $profile
    end
end
