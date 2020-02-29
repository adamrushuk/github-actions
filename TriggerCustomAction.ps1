# Trigger action with custom events
# Original ref: https://github.com/stefanstranger/githubactions

<#
    # Examples

    # Add GitHub Personal access token to env var
    $env:GITHUB_TOKEN = "<GITHUB_ACCESS_TOKEN>"

    # Trigger inline action
    TriggerCustomAction.ps1 -CustomEventAction "inline"

    # Trigger multi action
    TriggerCustomAction.ps1 -CustomEventAction "multi"

    # Trigger inline action
    TriggerCustomAction.ps1 -CustomEventAction "script"
#>

[CmdletBinding()]
param(
    # Personal Access Token stored as environment variable
    $GithubToken = $env:GITHUB_TOKEN,

    $GithubUserName = "adamrushuk",

    $GithubRepo = "github-actions",

    [ValidateSet("inline","multi","script")]
    $CustomEventAction = "inline"
)

$uri = "https://api.github.com/repos/$GithubUserName/$GithubRepo/dispatches"

$body = @{
    # used for if condition of Github Action
    "event_type" = "script"
} | ConvertTo-Json

$params = @{
    ContentType = "application/json"
    Headers     = @{
        "authorization" = "token $($GithubToken)"
        "accept"        = "application/vnd.github.everest-preview+json"
    }
    Method      = "Post"
    URI         = $uri
    Body        = $body
}

Invoke-RestMethod @params -Verbose
