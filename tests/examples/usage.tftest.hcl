mock_provider "azurerm" { source = "./tests/examples/mocks" }
mock_provider "random" { source = "./tests/examples/mocks" }

run "test_example_usage" {
  command = plan

  module {
    source = "./examples/usage"
  }
}
