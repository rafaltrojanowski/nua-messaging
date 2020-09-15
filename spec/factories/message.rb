FactoryBot.define do
  factory :message do
    body { "MyText" }
    inbox
    outbox
  end
end
