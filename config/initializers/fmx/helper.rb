module ApplicationHelper
  
  def abs_image_tag(path, args = {})
    url = URI.join(root_url, image_path(path))
    image_tag(url, args)
  end
  
  def abs_image_path(path, args = {})
    url = URI.join(root_url, image_path(path))
    image_path(url, args)
  end
  
  def t(key, opts = nil)
    I18n.t(key, opts).html_safe
  end
  
  def _t(key, opts = nil)
    I18n.t(key)
  end
  
  def section_action_defaults(opts)
    #requires namespace
    defaults = {
      list_action: { action: :list },
      list_params: {},
      display: :table
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:js_obj] = defaults[:js_obj].nil? ? defaults[:namespace] : defaults[:js_obj]
    defaults[:list_params].merge!(defaults[:params])
    defaults.merge!({
      section_wrapper_id: "#{defaults[:namespace]}_slider_wrapper",
      slides_cls: "#{defaults[:namespace]}_slide",
      table_id: "#{defaults[:namespace]}_table",
      js_parent_obj: "#{defaults[:js_parent]}.#{defaults[:js_obj]}"
    })
  end
  
  def section_defaults(opts)
    #requires namespace
    defaults = {
      add_perm: true,
      display: :table
    }
    defaults.merge!(opts)
    subsection_opts(defaults)
    defaults.merge!({
      section_wrapper_id: "#{defaults[:namespace]}_slider_wrapper",
      table_id: "#{defaults[:namespace]}_table"
    })
  end
  
  def section_header_defaults(opts)
    #requires namespace
    defaults = { namespace: opts[:namespace] }
    defaults = {
      show_add_btn: true,
      show_cancel_btn: false,
      add_btn_id: "#{defaults[:namespace]}_new_btn",
      cancel_btn_id: "#{defaults[:namespace]}_cancel_btn"
    }
    defaults.merge!(opts)
    subsection_opts(defaults)    
  end
  
  def section_form_defaults(element, opts)
    defaults = {
      new_record: element.new_record? ? 1 : 0, 
      form_url: element.new_record? ? { action: :create } : { action: :update, id: element.id },
      form_obj: "form",
      show_add_btn: false,
      show_cancel_btn: true,
      params: {}
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:form_url].merge!(defaults[:params])
    defaults[:js_obj] = defaults[:js_obj].nil? ? defaults[:namespace] : defaults[:js_obj]
    defaults.merge!({
      form_id: "#{defaults[:namespace]}_form", #
      lang_key: element.new_record? ? 'app.admin.actions.add_title' : 'app.admin.actions.edit_title',
      cancel_btn_id: "#{defaults[:namespace]}_form_cancel_btn" #
    })
    unless defaults[:title_lang_key].nil?
      defaults[:lang_key] = defaults[:title_lang_key]
    end
    defaults
  end
  
  def section_form_actions_defaults(opts, params)
    params[:new_record] = params[:new_record].to_i
    new_record = params[:new_record] == 1
    defaults = {
      form_obj: "form"
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:js_obj] = defaults[:js_obj].nil? ? defaults[:namespace] : defaults[:js_obj]
    defaults.merge!({
      form_id: "#{defaults[:namespace]}_form",
      js_parent_obj: "#{defaults[:js_parent]}.#{defaults[:js_obj]}",
      js_parent_obj_form: "#{defaults[:js_parent]}.#{defaults[:js_obj]}.#{defaults[:form_obj]}",
      success_lang_key: new_record ? 'app.admin.messages.create_success' : 'app.admin.messages.update_success',
      cancel_btn_id: "#{defaults[:namespace]}_form_cancel_btn"
    })
  end
  
  def section_show_action_defaults(opts)
    # requires namespace & show_action
    defaults = {
      show_action: { action: :show },
      perm: true,
      show_icon: 'show',
      lang_key: 'app.admin.actions.show',
      show_params: {}
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:show_params].merge!(defaults[:params])
    defaults.merge!({
      js_obj: "#{defaults[:namespace]}_show_action"
    })
  end
  
  def section_link_action_defaults(opts)
    # requires namespace, link_action, lang_key & link_icon
    defaults = {
      link_condition: true,
      link_params: {},
      link_new_window: false
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:link_params].merge!(defaults[:params])
    defaults.merge({
        js_obj: "#{defaults[:namespace]}_link_action"
    })
  end
  
  def section_dialog_action_defaults(opts)
    # requires namespace, dialog_icon, lang_key
    defaults = {
      dialog_condition: true,
      dialog_opts: {}
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults.merge({
        js_obj: "#{defaults[:namespace]}_dialog_action"
    })
  end
  
  def section_add_action_defaults(opts)
    #requires namespace
    defaults = {
      perm: true,
      add_action: { action: :new },
      add_params: {}
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:add_params].merge!(defaults[:params])
    defaults.merge!({
      add_btn_id: "#{defaults[:namespace]}_new_btn"
    })
  end
  
  def section_edit_action_defaults(opts)
    #requires namespace
    defaults = {
      perm: true,
      edit_action: { action: :edit },
      edit_params: {}
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:edit_params].merge!(defaults[:params])
    defaults.merge!({
      lang_key: 'app.admin.actions.edit',
      js_obj: "#{defaults[:namespace]}_edit_action"
    })
  end
  
  def section_js_action_defaults(opts)
    #requires lang key
    defaults = {
      perm: true
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults.merge!({
      js_obj: "#{defaults[:namespace]}_js_action"
    })
  end
  
  def section_delete_action_defaults(opts)
    #requires namespace
    defaults = {
      perm: true,
      delete_action: { action: :delete },
      delete_params: {}
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:delete_params].merge!(defaults[:params])
    defaults.merge!({
      lang_key: 'app.admin.actions.delete',
      success_lang_key: 'app.admin.messages.delete_success',
      js_obj: "#{defaults[:namespace]}_delete_action"
    })
  end
  
  def section_ajax_action_defaults(opts)
    #requires namespace & ajax icon
    defaults = {
      ajax_action: {},
      ajax_params: {},
      ajax_method: 'post',
      ajax_confirm: true,
      ajax_condition: true
    }
    defaults.merge!(section_js_defaults)
    defaults.merge!(opts)
    defaults[:ajax_params].merge!(defaults[:params])
    defaults.merge!({
      js_obj: "#{defaults[:namespace]}_ajax_action"
    })
  end
  
  private
  
  def subsection_opts(opts)
    if opts[:is_subsection]
      opts.merge!({      
        show_cancel_btn: true
      })
    end
    opts
  end
  
  def section_js_defaults
    {
      js_parent: "app.dashboard",
      slide_cls: 'section',
      is_subsection: false,
      params: {}
    }
  end
  

end
