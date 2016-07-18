require_relative '../test_helper'
class ModuleTest < Minitest::Test
	include Synthea
	def setup
		@person = Synthea::Person.new
		@time = Time.now
		@rule = Synthea::Rules.new
	end

	def test_prescribeMedication
		@rule.prescribeMedication(:glp1ra, :coronary_heart_disease, @time, @person)
		assert_equal([@time, [:coronary_heart_disease]], @person[:medications][:glp1ra])
		@rule.prescribeMedication(:glp1ra, :coronary_heart_disease, @time, @person)
		assert_equal([@time, [:coronary_heart_disease]], @person[:medications][:glp1ra])
		@rule.prescribeMedication(:glp1ra, :diabetes, @time, @person)
		assert_equal([@time, [:coronary_heart_disease, :diabetes]], @person[:medications][:glp1ra])
	end

	def test_stopMedication
		@rule.prescribeMedication(:prandial_insulin, :coronary_heart_disease, @time, @person)
		@rule.prescribeMedication(:prandial_insulin, :diabetes, @time, @person)
		@rule.stopMedication(:prandial_insulin, :random_reason, @time, @person)
		assert_equal([@time, [:coronary_heart_disease, :diabetes]], @person[:medications][:prandial_insulin])
		@rule.stopMedication(:prandial_insulin, :coronary_heart_disease, @time, @person)
		assert_equal([@time, [:diabetes]], @person[:medications][:prandial_insulin])
		@rule.stopMedication(:prandial_insulin, :diabetes, @time, @person)
		assert(@person[:medications][:prandial_insulin].nil?)
	end
end