# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

organization = Organization.create( name: "Provide Chat", email: "derek@providechat.com", edition: "ultimate", payment_system: "stripe" )
organization.save!

agent = Agent.create( name: "Derek Barber", organization_id: organization.id, email: "derek@providechat.com", password: "password", password_confirmation: "password", status: "enabled")
agent.save!

rapid_response1 = RapidResponse.create( organization_id: organization.id, name: "Sales", order: 1, status: "enabled" )
rapid_response1.save!
rapid_response2 = RapidResponse.create( organization_id: organization.id, name: "Support", order: 2, status: "enabled" )
rapid_response2.save!
rapid_response3 = RapidResponse.create( organization_id: organization.id, name: "Greetings", order: 3, status: "enabled" )
rapid_response3.save!

rapid_response4 = RapidResponse.create( organization_id: organization.id, name: "Getting Started", text: "Let me help you get started", order: 1, ancestry: rapid_response1.id, status: "enabled" )
rapid_response4.save!
rapid_response5 = RapidResponse.create( organization_id: organization.id, name: "Gage Interest", text: "What is your interest in this product?", order: 2, ancestry: rapid_response1.id, status: "enabled" )
rapid_response5.save!