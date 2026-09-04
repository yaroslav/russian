# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Russian, "Ractor readiness" do
  it "defines only Ractor-shareable constants" do
    unshareable = []

    each_constant(described_class) do |name, value|
      unshareable << name unless Ractor.shareable?(value)
    end

    expect(unshareable).to be_empty
  end

  it "transliterates inside a non-main Ractor" do
    result = in_ractor { Russian.transliterate("Привет, мир!") }

    expect(result).to eq("Privet, mir!")
  end

  def each_constant(namespace, &block)
    namespace.constants(false).sort.each do |name|
      value = namespace.const_get(name, false)
      full_name = "#{namespace}::#{name}"

      block.call(full_name, value)
      each_constant(value, &block) if value.is_a?(Module) && value.name == full_name
    end
  end

  def in_ractor(&block)
    ractor = silence_experimental_warning { Ractor.new(&block) }

    ractor.respond_to?(:value) ? ractor.value : ractor.take
  end

  def silence_experimental_warning
    original = Warning[:experimental]
    Warning[:experimental] = false

    yield
  ensure
    Warning[:experimental] = original
  end
end
