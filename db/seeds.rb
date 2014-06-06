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