//
//  JestTemplate.swift
//  TestKit
//
//  Created by Qiwei Li on 11/25/24.
//

extension Template {
    static let jestTemplate: Template = """
    {%- macro renderStep step counter -%}
        {%- if step.isTextInput %}
        // simulates typing in the text input
        await api.chatroom.sendMessageToChatroom(chatroomId, {
          content: "{{step.textInput.text}}",
          type: MessageType.Text,
        });
        await sleep(DEFAULT_RENDERING_WAIT_TIME);
        {%- endif -%}
        {%- if step.isButtonClick %}
        // click on the button
        await api.chatroom.clickOnMessageInChatroom(
          chatroomId,
          {{step.buttonClick.messageId}},
          {
            text: "{{step.buttonClick.buttonText}}",
          }
        );
        await sleep(DEFAULT_RENDERING_WAIT_TIME);
        {%- endif -%}
        {%- if step.isExpectMessageCount %}
        // expectMessageCount
        const messages{{counter}} = await api.chatroom.getMessagesByChatroom(chatroomId);
        {%- if step.expectMessageCount.comparison == "equals" %}
        expect(messages{{counter}}.data.messages.length).toBe({{step.expectMessageCount.count}});
        {%- elif step.expectMessageCount.comparison == "notEquals" %}
        expect(messages{{counter}}.data.messages.length).not.toBe({{step.expectMessageCount.count}});
        {%- elif step.expectMessageCount.comparison == "greaterThan" %}
        expect(messages{{counter}}.data.messages.length).toBeGreaterThan({{step.expectMessageCount.count}});
        {%- elif step.expectMessageCount.comparison == "lessThan" %}
        expect(messages{{counter}}.data.messages.length).toBeLessThan({{step.expectMessageCount.count}});
        {%- endif -%}
        {%- endif -%}
        {%- if step.isExpectMessageText %}
        // expectMessageText
        const message{{counter}} = (await api.chatroom.getMessagesByChatroom(chatroomId)).data.messages[{{step.expectMessageText.messageId}}];
        {%- if step.expectMessageText.comparison == "equals" %}
        expect(message{{counter}}?.text).toBe("{{step.expectMessageText.text}}");
        {%- elif step.expectMessageText.comparison == "notEquals" %}
        expect(message{{counter}}?.text).not.toBe("{{step.expectMessageText.text}}");
        {%- elif step.expectMessageText.comparison == "contains" %}
        expect(message{{counter}}?.text).toContain("{{step.expectMessageText.text}}");
        {%- elif step.expectMessageText.comparison == "notContains" %}
        expect(message{{counter}}?.text).not.toContain("{{step.expectMessageText.text}}");
        {%- endif -%}
        {%- endif -%}
        {%- if step.isGroup %}
        // Group: {{step.group.name|default:"Unnamed Group"}}
        await api.chatroom.getMessagesByChatroom(chatroomId); // Ensure messages are loaded for the group
        const groupMessage{{counter}} = (await api.chatroom.getMessagesByChatroom(chatroomId)).data.messages[{{step.group.messageId}}];
        {%- for childStep in step.children -%}
        {% call renderStep childStep counter -%}
        {%- endfor -%}
        {%- endif -%}
    {%- endmacro -%}

    import { Api, MessageType } from "@rx-lab/mock-telegram-client";
    import {
      CLIProcessManager,
      DEFAULT_RENDERING_WAIT_TIME,
      TestingEnvironment,
      initialize,
      sleep,
    } from "rxbot-cli/test";

    const chatroomId = 1000;
    const PORT = 9000;

    describe("{{testPlan.name}}", () => {
      let api: Api<any>;
      let coreApi: any | undefined;
      let cliProcessManager: CLIProcessManager | undefined;

      beforeAll(async () => {
        api = new Api({
          baseUrl: `http://0.0.0.0:${PORT}`,
        });
      });

      beforeEach(() => {
        coreApi = undefined;
        cliProcessManager = undefined;
      });

      it(`should be able to pass all tests`, async () => {
        const { core, processManager } = await initialize({
          filename: import.meta.url,
          environment,
          api,
          chatroomId,
        });
        cliProcessManager = processManager;
        coreApi = core;
        {%- for step in steps -%}
        {% call renderStep step forloop.counter -%}
        {%- endfor -%}
      });

      afterEach(async () => {
        await coreApi?.onDestroy();
        await cliProcessManager?.stop();
      });
    });
    """
}
