# frozen_string_literal: true

require "test_helper"

describe "Classic", :classic do
  it "must have version number" do
    _(::Classic::VERSION).wont_be :nil?
  end

  it "return classes for simple key -> label" do
    _("label".to_cls).must_equal "s-label"
  end

  it "return classes with extra classes -> label.to_cls('s-extra')" do
    _("label".to_cls("s-extra")).must_equal "s-label s-extra"
  end

  it "return classes for nested key -> inputs.selectbox.dropdown.options" do
    _("inputs.selectbox.dropdown.options".to_cls).must_equal "i-s-dropdown-option"
  end

  it "return style defined by default key expression -> btn" do
    _("btn".to_cls).must_equal "base v-default s-default"
  end

  it "style include base value -> btn" do
    _("btn".to_cls).must_include "base"
  end

  it "return style defined by <self key -> description_list" do
    _("description_list".to_cls).must_equal "dl-description-list-container"
  end

  it "return style defined by nested <self key -> description_list.header" do
    _("description_list.header".to_cls).must_equal "dl-header-container"
  end

  it "return style with default value -> description_list.item.layout" do
    _("description_list.item.layout".to_cls).must_equal "dl-item-layout-row"
  end

  it "return style with default value -> table" do
    _("table".to_cls).must_equal "t-default"
  end

  it "raise an error if style not find" do
    _ { "not-found".to_cls }.must_raise Classic::NotFoundError

    _ { "table.xyz".to_cls }.must_raise Classic::NotFoundError
  end

  describe "style expression" do
    it "combine muiltiple styles -> btn(variant.destructive,size.icon)" do
      _("btn(variant.destructive,size.icon)".to_cls).must_equal "base v-destructive s-icon"
    end

    it "single style expression -> btn(size.icon)" do
      _("btn(size.icon)".to_cls).must_equal "base s-icon"
    end

    it "combine nested muiltiple styles -> post_page(header.sm,item.content.variant.list)" do
      _("post_page(size.sm, header.size.sm, item.content.variant.list)".to_cls).must_equal "s-sm h-s-sm pp-v-list"
    end

    it "raise an error if sub or variant style not find" do
      _ { "btn(variant-np.destructive,size.icon)".to_cls }.must_raise Classic::NotFoundError
    end
  end

  describe "aliases" do
    it "return style using style alias" do
      _("btn-primary".to_cls).must_equal "base v-outline s-lg"
    end
  end

  it "raise an error if dublicate keys in other files" do
    Classic.object.config.files << "test/fixtures/style/dublicate.keys"

    err = _{ Classic.reload! }.must_raise Classic::Error
    _(err.message).must_match /dublicate value found for table/i

    Classic.object.config.files.pop
    Classic.reload!
  end

  it "add file prefix to keys" do
    Classic.object.config.file_prefix = true
    Classic.reload!

    _("components.btn-primary".to_cls).must_equal "base v-outline s-lg"
    _("components.btn(variant.destructive,size.icon)".to_cls).must_equal "base v-destructive s-icon"
    _("app.table".to_cls).must_equal "t-default"

    Classic.object.config.file_prefix = false
    Classic.reload!
  end
end
