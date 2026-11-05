# Run personally after reviewing both contributions and agreeing to the DCO:
# https://developercertificate.org/
# Compatible with Windows PowerShell 5.1 and PowerShell 7.
# The checkout-free clones avoid Windows path problems. read-tree populates
# the index, and tree/parent checks prevent an accidental empty-tree commit.
$ErrorActionPreference = 'Stop'

function Invoke-GitChecked {
    param([string[]]$GitArguments)
    $output = & git @GitArguments
    if ($LASTEXITCODE -ne 0) {
        throw ('Git failed: git ' + ($GitArguments -join ' '))
    }
    return $output
}

$Contributions = @(
    @{ Number = '2490'; Branch = 'test/2490-rag-query-transformers'; Head = 'fd422ea441c4d0bcf4c03e038352cf7849f296bd'; Tree = '770fea63872797495408a927e567fdb1417b1c1f' },
    @{ Number = '2224'; Branch = 'test/2224-ragas-langfuse-observer'; Head = 'aba6d5f057034da8a0496107ba01f3e52bb7997e'; Tree = '5f3cb6d810862f701a6444b7505624959d0e9504' }
)
$BaseCommit = '58440eb921b9fcefb17c770616362e5ac00bde6a'
$RepositoryUrl = 'https://github.com/XVSHIFU/llm4s.git'
$Destination = Join-Path (Get-Location) ('llm4s-signoff-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Path $Destination | Out-Null

foreach ($Contribution in $Contributions) {
    $RepositoryPath = Join-Path $Destination $Contribution.Number
    Write-Host ('Signing issue #' + $Contribution.Number)
    Invoke-GitChecked -GitArguments @('clone', '--no-checkout', '--single-branch', '--branch', $Contribution.Branch, $RepositoryUrl, $RepositoryPath)
    $Head = Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'rev-parse', 'HEAD')
    $Tree = Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'rev-parse', 'HEAD^{tree}')
    $Parent = Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'rev-parse', 'HEAD^')
    if ($Head -ne $Contribution.Head -or $Tree -ne $Contribution.Tree -or $Parent -ne $BaseCommit) {
        throw 'The remote contribution changed. Stop here and ask Codex to check it.'
    }

    Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'read-tree', 'HEAD')
    Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'commit', '--amend', '--no-edit', '--reset-author', '--signoff')
    $SignedTree = Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'rev-parse', 'HEAD^{tree}')
    $SignedParent = Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'rev-parse', 'HEAD^')
    if ($SignedTree -ne $Contribution.Tree -or $SignedParent -ne $BaseCommit) {
        throw 'The signed commit does not match the tested code. Nothing was pushed for this contribution.'
    }

    $Lease = '--force-with-lease=refs/heads/' + $Contribution.Branch + ':' + $Contribution.Head
    $Refspec = 'HEAD:refs/heads/' + $Contribution.Branch
    Invoke-GitChecked -GitArguments @('-C', $RepositoryPath, 'push', $Lease, 'origin', $Refspec)
    Write-Host ('Issue #' + $Contribution.Number + ': signed and pushed successfully.')
}

Write-Host 'Both contributions are signed and pushed. Tell Codex to verify and submit the two PRs.'
