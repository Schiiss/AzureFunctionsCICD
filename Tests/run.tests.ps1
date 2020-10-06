Describe "Testing" {
    It "Returns Conner"{
        $response = Invoke-RestMethod -Method Get -Uri https://pshelltest3344.azurewebsites.net/api/HttpTrigger?name=conner
        $response | Should -Be "Hello, conner. This HTTP triggered function executed successfully."
    }
}