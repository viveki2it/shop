# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130620134454) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "alerted_full_items", :id => false, :force => true do |t|
    t.integer "full_item_id"
    t.integer "user_id"
  end

  create_table "blacklisted_urls", :force => true do |t|
    t.text     "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.integer  "master_category_id"
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "categories_full_items", :force => true do |t|
    t.integer "full_item_id", :null => false
    t.integer "category_id",  :null => false
  end

  create_table "full_item_histories", :force => true do |t|
    t.float    "normal_price"
    t.float    "sale_price"
    t.float    "original_price"
    t.boolean  "enabled"
    t.boolean  "valid_item"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "full_item_id"
    t.float    "selected_price"
  end

  add_index "full_item_histories", ["full_item_id"], :name => "index_full_item_histories_on_full_item_id"

  create_table "full_items", :force => true do |t|
    t.integer  "retailer_id"
    t.float    "normal_price"
    t.float    "sale_price"
    t.float    "selected_price"
    t.text     "image_path"
    t.string   "gender"
    t.text     "identifier"
    t.text     "link"
    t.boolean  "enabled"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "on_sale"
    t.integer  "full_item_id"
    t.float    "sale_original_price"
    t.datetime "last_scraped"
    t.datetime "last_visited"
    t.integer  "scrape_fail_count",    :default => 0
    t.integer  "scrape_success_count", :default => 0
  end

  create_table "full_items_retailer_colours", :id => false, :force => true do |t|
    t.integer "full_item_id",       :null => false
    t.integer "retailer_colour_id", :null => false
  end

  create_table "full_items_sales_alerts", :id => false, :force => true do |t|
    t.integer "full_item_id"
    t.integer "sales_alert_id"
  end

  create_table "interactions", :force => true do |t|
    t.string   "user_identifier"
    t.string   "event_type"
    t.integer  "count"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "user_agent"
  end

  create_table "invites", :force => true do |t|
    t.string   "code"
    t.integer  "ambassador_id"
    t.boolean  "include_in_leaderboard"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "landing_page_variant_id"
    t.string   "owner"
    t.string   "proposition_code"
    t.text     "proposition_details"
    t.string   "image_code"
    t.string   "advert_heading"
    t.text     "advert_body"
    t.integer  "download_button_clicks",  :default => 0
  end

  create_table "items", :force => true do |t|
    t.integer  "supported_domain_id"
    t.text     "title"
    t.text     "image"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "identifier"
    t.text     "url"
    t.text     "image_link"
    t.text     "base64_image"
    t.float    "price"
  end

  create_table "items_categories", :force => true do |t|
    t.integer  "item_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "landing_page_layouts", :force => true do |t|
    t.string   "title"
    t.string   "partial"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "landing_page_variants", :force => true do |t|
    t.string   "internal_title"
    t.text     "internal_description"
    t.integer  "landing_page_layout_id"
    t.text     "heading1"
    t.text     "heading2"
    t.text     "description"
    t.string   "download_button_text"
    t.string   "hero_image"
    t.text     "box1"
    t.text     "box2"
    t.text     "box3"
    t.boolean  "show_trending"
    t.boolean  "show_supported_shops"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.boolean  "show_three_boxes"
    t.boolean  "chrome_inline_install"
  end

  create_table "master_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "male_name"
    t.string   "only_show_to"
  end

  create_table "master_colours", :force => true do |t|
    t.string   "name"
    t.string   "swatch"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.string   "name"
    t.text     "email"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "on_sale_items", :force => true do |t|
    t.integer  "full_item_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "recommendable_dislikes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "dislikeable_id"
    t.string   "dislikeable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "recommendable_dislikes", ["dislikeable_id"], :name => "index_recommendable_dislikes_on_dislikeable_id"
  add_index "recommendable_dislikes", ["dislikeable_type"], :name => "index_recommendable_dislikes_on_dislikeable_type"
  add_index "recommendable_dislikes", ["user_id", "dislikeable_id", "dislikeable_type"], :name => "user_dislike_constraint", :unique => true

  create_table "recommendable_ignores", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ignorable_id"
    t.string   "ignorable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "recommendable_ignores", ["ignorable_id"], :name => "index_recommendable_ignores_on_ignorable_id"
  add_index "recommendable_ignores", ["ignorable_type"], :name => "index_recommendable_ignores_on_ignorable_type"
  add_index "recommendable_ignores", ["user_id", "ignorable_id", "ignorable_type"], :name => "user_ignore_constraint", :unique => true

  create_table "recommendable_likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "recommendable_likes", ["likeable_id"], :name => "index_recommendable_likes_on_likeable_id"
  add_index "recommendable_likes", ["likeable_type"], :name => "index_recommendable_likes_on_likeable_type"
  add_index "recommendable_likes", ["user_id", "likeable_id", "likeable_type"], :name => "user_like_constraint", :unique => true

  create_table "recommendable_stashes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "stashable_id"
    t.string   "stashable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "recommendable_stashes", ["stashable_id"], :name => "index_recommendable_stashes_on_stashable_id"
  add_index "recommendable_stashes", ["stashable_type"], :name => "index_recommendable_stashes_on_stashable_type"
  add_index "recommendable_stashes", ["user_id", "stashable_id", "stashable_type"], :name => "user_stashed_constraint", :unique => true

  create_table "recorded_likes", :force => true do |t|
    t.integer  "full_item_id"
    t.integer  "user_id"
    t.string   "source"
    t.datetime "recorded_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "retailer_categories", :force => true do |t|
    t.string   "name"
    t.integer  "retailer_id"
    t.integer  "master_category_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "retailer_colours", :force => true do |t|
    t.string   "name"
    t.integer  "retailer_id"
    t.integer  "master_colour_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "retailer_reports", :force => true do |t|
    t.string   "slug"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "retailers", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "domain"
    t.boolean  "enabled"
    t.boolean  "index_based"
    t.integer  "index"
    t.boolean  "param_based"
    t.string   "param_name"
    t.boolean  "url_based"
    t.string   "image_selector"
    t.boolean  "colour_dropdown"
    t.string   "colour_dropdown_selector"
    t.boolean  "colour_link"
    t.string   "colour_link_selector"
    t.boolean  "normal_simple_price"
    t.string   "normal_simple_price_selector"
    t.boolean  "normal_composite_price"
    t.string   "normal_composite_price_selectors"
    t.string   "normal_composite_price_indexes"
    t.string   "normal_remove_from_price"
    t.boolean  "sale_simple_price"
    t.string   "sale_simple_price_selector"
    t.boolean  "sale_composite_price"
    t.string   "sale_composite_price_selectors"
    t.string   "sale_composite_price_indexes"
    t.string   "sale_remove_from_price"
    t.string   "category_selector"
    t.boolean  "always_male"
    t.boolean  "always_female"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "sale_original_price"
    t.boolean  "sale_original_price_simple_price"
    t.string   "sale_original_price_simple_price_selector"
    t.boolean  "sale_original_price_composite_price"
    t.string   "sale_original_price_composite_price_selectors"
    t.string   "sale_original_price_composite_price_indexes"
    t.text     "sale_original_price_remove_from_price"
    t.text     "normal_item_url"
    t.text     "sale_item_url"
    t.boolean  "use_affiliate_window"
    t.string   "affiliate_window_awinmid"
    t.boolean  "use_linkshare"
    t.string   "linkshare_offerid"
    t.string   "linkshare_tmpid"
    t.boolean  "supported_for_sales"
  end

  create_table "sales_alerts", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "email_sent", :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "scrape_records", :force => true do |t|
    t.integer  "retailer_id"
    t.integer  "succesful_items"
    t.integer  "enabled_items"
    t.integer  "failed_items"
    t.integer  "error_items"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "signups", :force => true do |t|
    t.text     "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "invite_id"
  end

  create_table "supported_domains", :force => true do |t|
    t.string   "domain"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "index_based"
    t.integer  "index"
    t.boolean  "param_based"
    t.string   "param_key"
    t.string   "selector"
    t.string   "category_selector"
    t.boolean  "no_price"
    t.boolean  "use_simple_price_selector"
    t.string   "simple_price_selector"
    t.boolean  "use_composite_price_selector"
    t.string   "composite_price_selector"
    t.string   "composite_price_selector_index"
    t.boolean  "dont_display"
  end

  create_table "user_recs", :id => false, :force => true do |t|
    t.integer "full_item_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "identifier"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "score"
    t.boolean  "migrated_to_new_scraper", :default => true
    t.string   "invite_code"
    t.datetime "last_started_extension"
    t.string   "extension_version"
    t.integer  "invite_id"
    t.datetime "last_active"
    t.string   "last_ip"
    t.string   "last_ip_country"
    t.string   "email"
    t.string   "tracking_code"
  end

  create_table "visits", :force => true do |t|
    t.text     "site"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

end
