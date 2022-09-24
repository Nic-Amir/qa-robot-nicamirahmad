*** Settings ***
Library   SeleniumLibrary

*** Variables ***
${nic_email}  email@email.com
${nic_pw}    password123



${login_button}      //button[@id='dt_login_button']
${email_field}    //input[@type='email']
${pw_field}   //input[@type='password']
${rise_button}  //div[@class='btn-purchase__text_wrapper']
${submit_button}   //button[@type='submit']



${drop_down_button}    dt_core_account-info_acc-info
${real_acc}    //*[starts-with(@id, 'dt_CR')]
${demo_button}    dt_core_account-switcher_demo-tab
${demo_switch}    dt_VRTC6201767


${select_symbol_button}    //div[@class='cq-menu-btn'] 
${syn_index_button}     //div[@class='sc-mcd__filter__item sc-mcd__filter__item--selected'] 


${1hz10v_button}    //*[contains(@class, '1HZ10V')]
${audusd_button}    //*[contains(@class, 'frxAUDUSD')]
${r50_button}    //*[contains(@class, 'R_50')]


${duration_field}    //input[@class='dc-input__field']
${payout_field}    //input[@class='dc-input-wrapper__input input--has-inline-prefix input trade-container__input']
${barrier_field}    //input[@class='input trade-container__input trade-container__barriers-input trade-container__barriers-single-input']

${disabled_put}    //*[contains(@class, 'disabled')]
${absolute_barrier_error_text}    //div[contains(string(), "Contracts more than 24 hours")]

${deal_cancel_checkbox}   //span[@class='dc-text dc-checkbox__label']
${stoploss_checkbox}   //span[@class='dc-text dc-checkbox__label stop_loss-checkbox__label']  
${takeprofit_checkbox}   //span[@class='dc-text dc-checkbox__label take_profit-checkbox__label'] 


${stake_field}    //input[contains(@class,'dc-input-wrapper__input input--has-inline-prefix')]














*** Keywords ***

Login To Deriv
    Open Browser    https://app.deriv.com/    chrome
    Set Selenium Speed     0.125
    Maximize Browser Window
    Wait Until Page Contains Element   ${rise_button}     30
    Click Element    ${login_button} 
    Wait Until Page Contains Element   ${email_field}    100
    Input Text   ${email_field}    ${nic_email}
    Input Text    ${pw_field}   ${nic_pw}
    Click Element    //button[@type='submit']

Check Real
    Wait Until Page Contains Element   ${rise_button}     30
    Wait Until Element Contains    ${drop_down_button}    USD    10
    Click Element    ${drop_down_button}
    Wait Until Page Contains Element   ${real_acc}    30
    Page Should Contain Element    ${real_acc}
    Click Element    ${real_acc}
    
Switch to Demo
    Wait Until Element Contains    ${drop_down_button}    USD    10
    Sleep     5
    Click Element    ${drop_down_button}
    Wait Until Page Contains Element   ${demo_button}  30
    Click Element  ${demo_button}
    Wait Until Page Contains Element    ${demo_switch}
    Click Element  ${demo_switch}
    Wait Until Page Contains Element   ${rise_button}     30



Verify if in Demo
    Page Should Contain Element    //*[local-name()='use' and contains(@*,'virtual')]

Navigate to 1HZ10V
    Wait Until Page Contains Element    ${select_symbol_button}  10
    Sleep     5
    Click Element    ${select_symbol_button}
    Sleep    5
    Click Element    ${syn_index_button}  
    Wait Until Page Contains Element    ${1hz10v_button}   30
    Click Element    ${1hz10v_button}

Buy Rise in 1HZ10V
    Wait Until Page Contains Element   dt_purchase_call_button
    Sleep    1
    Click Element    dt_purchase_call_button 


Navigate to AUD/USD
    Wait Until Page Contains Element    ${select_symbol_button}  10
    Sleep    5
    Click Element    ${select_symbol_button}
    Sleep    5
    Click Element    ${syn_index_button}  
    Wait Until Page Contains Element    ${audusd_button}  30
    Click Element    ${audusd_button}

Change from Rise/Fall to High/Low
    Wait Until Page Contains Element    dt_contract_dropdown     30
    Click Element     dt_contract_dropdown
    Wait Until Page Contains Element    dt_contract_high_low_item     30
    Click Element     dt_contract_high_low_item

Buy Lower, 4days, 15.50USD
    Press Keys    ${duration_field}     CTRL+A+DELETE     4
    Click Element    dc_payout_toggle_item    
    Press Keys    ${payout_field}    CTRL+A+DELETE      15.50
    Click Element    dt_purchase_put_button

Buy with ivalid barrier
    
    Press Keys    ${duration_field}     CTRL+A+DELETE     4
    Click Element    dc_payout_toggle_item    
    Press Keys    ${payout_field}    CTRL+A+DELETE      10
    Press Keys    ${barrier_field}    CTRL+A+DELETE      -0.317
    
    Wait Until Page Contains Element    ${disabled_put}    30
    Wait Until Page Contains Element    ${absolute_barrier_error_text}     30
    Page Should Contain    Contracts more than 24 hours

Navigate to R_50
    Wait Until Page Contains Element    ${select_symbol_button}  10
    Sleep    5
    Click Element    ${select_symbol_button}
    Sleep    5
    Click Element    ${syn_index_button}  
    Wait Until Page Contains Element    ${select_symbol_button}    30
    Click Element    ${r50_button}  

Change from Rise/Fall to Multiplyer
    Wait Until Page Contains Element    dt_contract_dropdown     30
    Click Element     dt_contract_dropdown
    Wait Until Page Contains Element    dt_contract_multiplier_item     30
    Click Element     dt_contract_multiplier_item



*** Test Cases *** 


Task 1
    Login To Deriv
    Check Real
    Switch to Demo
    Verify if in Demo

Task 2
    Navigate to 1HZ10V
    Buy Rise in 1HZ10V

# Task 3
#     Navigate to AUD/USD
#     Change from Rise/Fall to High/Low
#     Buy Lower, 4days, 15.50USD

# Task 4
#     Buy with ivalid barrier
    

Task 5
    Navigate to R_50
    Change from Rise/Fall to Multiplyer
    Sleep    3

task 5a 
    Wait Until Page Contains Element    //span[contains(string(), "Stake")]    30
    Page Should Contain    Stake
    Page Should Not Contain    Payout

task 5b
    Click Element    ${stoploss_checkbox}  
    Sleep    2 
    Click Element    ${takeprofit_checkbox} 
    Sleep    2
    Click Element     ${deal_cancel_checkbox} 
    
    Page Should Contain Element  //label[@class='dc-checkbox']/span[@class="dc-checkbox__box dc-checkbox__box--active"]
    Page Should Not Contain Element    //label[@class='dc-checkbox take_profit-checkbox__input']/span[@class='dc-checkbox__box dc-checkbox__box--active']
    Page Should Not Contain Element    //label[@class='dc-checkbox stop_loss-checkbox__input']/span[@class='dc-checkbox__box dc-checkbox__box--active']

task 5c
    Click Element   //div[@class='dc-dropdown__display dc-dropdown__display--no-border']
    
    sleep    1

    Page Should Contain Element  //div[@value='20']
    Page Should Contain Element  //div[@value='40']
    Page Should Contain Element  //div[@value='60']
    Page Should Contain Element  //div[@value='100']
    Page Should Contain Element  //div[@value='200']

    Sleep    1

    Click Element   //div[@class='dc-dropdown__display dc-dropdown__display--no-border']

task 5d
    Press Keys    ${stake_field}     CTRL+A+DELETE     10
    Wait Until Page Contains Element     //div[@class='trade-container__price-info-value']/span[contains(string(),'0.44 USD')]
    Press Keys    ${stake_field}     CTRL+A+DELETE     20
    Wait Until Page Contains Element     //div[@class='trade-container__price-info-value']/span[contains(string(),'0.87 USD')]
    Press Keys    ${stake_field}     CTRL+A+DELETE     100
    Wait Until Page Contains Element    //div[@class='trade-container__price-info-value']/span[contains(string(),'4.37 USD')]
    

task 5e
    Press Keys    ${stake_field}     CTRL+A+DELETE     0.09
    Wait Until Page Contains Element    //span[contains(@data-tooltip,'at least 1.00')]     30
    Page Should Contain Element    //span[contains(@data-tooltip,'at least 1.00')]

task 5f
    Press Keys    ${stake_field}     CTRL+A+DELETE     1
    Page Should Not Contain    //span[contains(@data-tooltip,'at least 1.00')]
    
    Press Keys    ${stake_field}     CTRL+A+DELETE     2001
    Wait Until Page Contains Element    //span[contains(string(),'Maximum stake allowed is 2000')]    30
    Page Should Contain Element    //span[contains(string(),'Maximum stake allowed is 2000')]

    Press Keys    ${stake_field}     CTRL+A+DELETE     2000
    Page Should Not Contain Element    //span[contains(string(),'Maximum stake allowed is 2000')]
task 5g
    ${before_value}=    Get Element Attribute    ${stake_field}    value
    Click Element    dt_amount_input_add
    ${after_value}=    Get Element Attribute    ${stake_field}    value
    ${shouldbeone}=    Set Variable    ${${after_value} - ${before_value}}
    Should Be True      ${shouldbeone} == 1
task 5h
    ${before_value2}=    Get Element Attribute    ${stake_field}    value
    Click Element    dt_amount_input_sub
    ${after_value2}=    Get Element Attribute    ${stake_field}    value
    ${shouldbeone2}=    Set Variable    ${${before_value2} - ${after_value2}}
    Should Be True      ${shouldbeone2} == 1
task 5i
    Click Element    //fieldset[input[@name='cancellation_duration'] and //*[name()='use' and @*[contains(string(),'chevron-left')]]]/div[2]/div
    Sleep    1
    Page Should Contain Element    //div[@value='5m']
    Page Should Contain Element    //div[@value='10m']
    Page Should Contain Element    //div[@value='15m']
    Page Should Contain Element    //div[@value='30m']
    Page Should Contain Element    //div[@value='60m']

























    













