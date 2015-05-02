# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

organization = Organization.create( payment_system: "stripe", status: "enabled", account_type: "paid" )
organization.save!

agent = Agent.create( name: "Derek Barber", display_name: "Derek", title: "Support Hero", organization_id: organization.id, access_level: "superadmin", email: "derek@providechat.com", password: "password", password_confirmation: "password", status: "enabled")
agent.save!

#website = Website.create( organization: organization.id, url: "http://www.providechat.dev", name: "Provide Chat", email: "derek@smartsettle.com")

#rapid_response1 = RapidResponse.create( organization_id: organization.id, name: "Sales", order: 1)
#rapid_response1.save!
#rapid_response2 = RapidResponse.create( organization_id: organization.id, name: "Support", order: 2)
#rapid_response2.save!
#rapid_response3 = RapidResponse.create( organization_id: organization.id, name: "Greetings", order: 3)
#rapid_response3.save!

#rapid_response4 = RapidResponse.create( organization_id: organization.id, name: "Getting Started", text: "Let me help you get started", order: 1, ancestry: rapid_response1.id)
#rapid_response4.save!
#rapid_response5 = RapidResponse.create( organization_id: organization.id, name: "Gage Interest", text: "What is your interest in this product?", order: 2, ancestry: rapid_response1.id)
#rapid_response5.save!