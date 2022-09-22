*** Settings ***
Library   SeleniumLibrary

*** Variables ***
${login_button}      //button[@id='dt_login_button']
${email_field}    //input[@type='email']
${pw_field}   //input[@type='password']
${rise_button}  //div[@class='btn-purchase__text_wrapper']
${submit_button}   //button[@type='submit']
${nic_email}  amir@besquare.com.my
${nic_pw}    987Luke!@#
${drop_down_button}    dt_core_account-info_acc-info
${real_acc}    //*[starts-with(@id, 'dt_CR')]
${demo_button}    dt_core_account-switcher_demo-tab
${demo_switch}    dt_VRTC6201767

































*** Test Cases *** 
Login To Deriv
    Open Browser    https://app.deriv.com/    chrome
    Maximize Browser Window
    Wait Until Page Contains Element   ${rise_button}     30
    Click Element    ${login_button} 
    Wait Until Page Contains Element   ${email_field}    100
    Input Text   ${email_field}    ${nic_email}
    Input Text    ${pw_field}   ${nic_pw}
    Click Element    //button[@type='submit']

Check Real
    Wait Until Page Contains Element   ${rise_button}     30
    Click Element    ${drop_down_button}
    Wait Until Page Contains Element   ${real_acc}    30
    Page Should Contain Element    ${real_acc}
    Click Element   ${real_acc}


Switch to Demo
    Click Element    ${drop_down_button}
    Wait Until Page Contains Element   ${demo_button}  5
    Click Element  ${demo_button}
    Wait Until Page Contains Element    ${demo_switch}
    Click Element  ${demo_switch}

Verify if in Demo
    Wait Until Page Contains Element    ${drop_down_button}  10
    Wait Until Element Contains    ${drop_down_button}    USD
    Click Element    ${drop_down_button}
    Wait Until Element Is Visible   ${demo_switch}   10
