<%--
/**
 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<%
PortletURL portletURL = (PortletURL)request.getAttribute("view.jsp-portletURL");
%>

<aui:form method="post" name="fm">
	<aui:input name="deleteMBMessageIds" type="hidden" />
	<aui:input name="notSpamMBMessageIds" type="hidden" />

	<liferay-ui:search-container
		emptyResultsMessage="there-are-no-posts"
		headerNames="subject,preview,posted-by"
		iteratorURL="<%= portletURL %>"
		rowChecker="<%= new RowChecker(renderResponse) %>"
	>
		<liferay-ui:search-container-results
			results="<%= MBMessageLocalServiceUtil.getGroupMessages(scopeGroupId, WorkflowConstants.STATUS_DENIED, searchContainer.getStart(), searchContainer.getEnd()) %>"
			total="<%= MBMessageLocalServiceUtil.getGroupMessagesCount(scopeGroupId, WorkflowConstants.STATUS_DENIED) %>"
		/>

		<c:if test="<%= !results.isEmpty() %>">
			<aui:button-row>
				<aui:button onClick='<%= renderResponse.getNamespace() + "notSpam();" %>' value="not-spam" />

				<aui:button onClick='<%= renderResponse.getNamespace() + "deleteMBMessages();" %>' value="delete" />
			</aui:button-row>
		</c:if>

		<liferay-ui:search-container-row
			className="com.liferay.portlet.messageboards.model.MBMessage"
			escapedModel="<%= true %>"
			keyProperty="messageId"
			modelVar="message"
		>

			<%
			long messageBoardsPlid = PortalUtil.getPlidFromPortletId(message.getGroupId(), PortletKeys.MESSAGE_BOARDS);
			%>

			<liferay-portlet:renderURL plid="<%= messageBoardsPlid %>" portletName="<%= PortletKeys.MESSAGE_BOARDS %>" varImpl="rowURL">
				<portlet:param name="struts_action" value="/message_boards/view_message" />
				<portlet:param name="messageId" value="<%= String.valueOf(message.getMessageId()) %>" />
			</liferay-portlet:renderURL>

			<liferay-ui:search-container-column-text
				href="<%= rowURL %>"
				name="subject"
				value="<%= message.getSubject() %>"
			/>

			<liferay-ui:search-container-column-text
				href="<%= rowURL %>"
				name="preview"
				value="<%= StringUtil.shorten(message.getBody(), 100) %>"
			/>

			<liferay-ui:search-container-column-text
				href="<%= rowURL %>"
				name="posted-by"
			>
				<div>
					<%= message.isAnonymous() ? LanguageUtil.get(pageContext, "anonymous") : HtmlUtil.escape(PortalUtil.getUserName(message.getUserId(), message.getUserName())) %>
				</div>

				<div>
					<%= longDateFormatDate.format(message.getCreateDate()) %>
				</div>
			</liferay-ui:search-container-column-text>

			<liferay-ui:search-container-column-jsp
				align="right"
				path="/moderation/message_boards_action.jsp"
			/>
		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator />
	</liferay-ui:search-container>
</aui:form>

<aui:script>
	Liferay.provide(
		window,
		'<portlet:namespace />deleteMBMessages',
		function() {
			if (confirm('<%= UnicodeLanguageUtil.get(pageContext, "are-you-sure-you-want-to-delete-the-selected-messages") %>')) {
				document.<portlet:namespace />fm.<portlet:namespace />deleteMBMessageIds.value = Liferay.Util.listCheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
				submitForm(document.<portlet:namespace />fm, "<portlet:actionURL name="deleteMessages"><portlet:param name="redirect" value="<%= currentURL %>" /></portlet:actionURL>");
			}
		},
		['liferay-util-list-fields']
	);

	Liferay.provide(
		window,
		'<portlet:namespace />notSpam',
		function() {
			if (confirm('<%= UnicodeLanguageUtil.get(pageContext, "are-you-sure-you-want-to-mark-the-selected-messages-as-not-spam") %>')) {
				document.<portlet:namespace />fm.<portlet:namespace />notSpamMBMessageIds.value = Liferay.Util.listCheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
				submitForm(document.<portlet:namespace />fm, "<portlet:actionURL name="markNotSpam"><portlet:param name="redirect" value="<%= currentURL %>" /></portlet:actionURL>");
			}
		},
		['liferay-util-list-fields']
	);
</aui:script>