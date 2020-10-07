Describe "Testing" {
    It "Returns Conner"{
        $response = Invoke-RestMethod -Method Get -Uri http://localhost:7071/api/HttpTrigger?name=conner
        $response | Should -Be "Hello, conner. This HTTP triggered function executed successfully."
    }
}