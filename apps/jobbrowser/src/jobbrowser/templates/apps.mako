## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%
  from desktop.views import commonheader, commonfooter
  from django.utils.translation import ugettext as _
%>

<%namespace name="require" file="/require.mako" />

${ commonheader("Job Browser", "jobbrowser", user, request) | n,unicode }

${ require.config() }


<div class="navbar navbar-inverse navbar-fixed-top nokids">
    <div class="navbar-inner">
      <div class="container-fluid">
        <div class="nav-collapse">
          <ul class="nav">
            <li class="currentApp">
              <a href="/${app_name}">
                <img src="${ static('jobbrowser/art/icon_jobbrowser_48.png') }" class="app-icon"/>
                ${ _('Job Browser') }
              </a>
            </li>
          </ul>
          % if not hiveserver2_impersonation_enabled:
            <div class="pull-right alert alert-warning" style="margin-top: 4px">${ _("Hive jobs are running as the 'hive' user") }</div>
          % endif
        </div>
      </div>
    </div>
</div>


<div class="container-fluid">
  <!-- ko if: $root.section() == 'app' -->
  <a href="javascript:void(0)" data-bind="click: function() { $root.section('apps'); }">
    <h2>${ _('Apps') } ></h2>
  </a>
  <!-- /ko -->

  <!-- ko if: $root.section() == 'apps' -->
  <h2>${ _('Apps') }</h2>
  ${_('Username')} <input id="userFilter" type="text" class="input-medium search-query" placeholder="${_('Search for username')}" value="${ user_filter or '' }">
  &nbsp;&nbsp;${_('Text')} <input id="textFilter" type="text" class="input-xlarge search-query" placeholder="${_('Search for id, name, status...')}" value="${ text_filter or '' }">

  <span>
    <span><input class="btn btn-status" type="radio" name="interface" value="jobs" data-bind="checked: interface" />${ _('Jobs') }</span>
    <span><input class="btn btn-status" type="radio" name="interface" value="batches" data-bind="checked: interface" />${ _('Batches') }</span>
    <span><input class="btn btn-status" type="radio" name="interface" value="schedules" data-bind="checked: interface" />${ _('Schedules') }</span>
  </span>

  <span class="btn-group">
    <span class="btn-group">
      <a class="btn btn-status btn-success" data-value="completed">${ _('Succeeded') }</a>
      <a class="btn btn-status btn-warning" data-value="running">${ _('Running') }</a>
      <a class="btn btn-status btn-danger disable-feedback" data-value="failed">${ _('Failed') }</a>
    </span>
  </span>

  <div class="card card-small">
    <table id="jobsTable" class="datatables table table-condensed">
      <thead>
      <tr>
        <th>${_('Logs')}</th>
        <th>${_('Id')}</th>
        <th>${_('Name')}</th>
        <th>${_('Type')}</th>
        <th>${_('Status')}</th>
        <th>${_('User')}</th>
        <th>${_('Progress')}</th>
        <th>${_('Duration')}</th>
        <th>${_('Submitted')}</th>
      </tr>
      </thead>
      <tbody data-bind="foreach: jobs.apps">
        <tr data-bind="click: fetchJob">
          <td></td>
          <td data-bind="text: id"></td>
          <td data-bind="text: name"></td>
          <td data-bind="text: type"></td>
          <td data-bind="text: status"></td>
          <td data-bind="text: user"></td>
          <td data-bind="text: progress"></td>
          <td data-bind="text: duration"></td>
          <td data-bind="text: submitted"></td>
        </tr>
      </tbody>
    </table>
  </div>
  <!-- /ko -->
</div>


<!-- ko if: $root.section() == 'app' && $root.job() -->
  <!-- ko if: $root.job().mainType() == 'jobs' && $root.interface() == 'jobs' -->
    <div data-bind="template: { name: 'job-page', data: $root.job() }"></div>
  <!-- /ko -->

  <!-- ko if: $root.job().mainType() == 'batches' && $root.interface() == 'batches' -->
    <div data-bind="template: { name: 'batch-page', data: $root.job() }"></div>
  <!-- /ko -->

  <!-- ko if: $root.job().mainType() == 'schedules' && $root.interface() == 'schedules' -->
    <div data-bind="template: { name: 'schedule-page', data: $root.job() }"></div>
  <!-- /ko -->
<!-- /ko -->


<script type="text/html" id="job-page">
  <!-- ko if: type() == 'MAPREDUCE' -->
    <div data-bind="template: { name: 'job-mapreduce-page', data: $root.job() }"></div>
  <!-- /ko -->

  <!-- ko if: type() == 'YARN' -->
    <div data-bind="template: { name: 'job-yarn-page', data: $root.job() }"></div>
  <!-- /ko -->

  <!-- ko if: type() == 'IMPALA' -->
    <div data-bind="template: { name: 'job-impala-page', data: $root.job() }"></div>
  <!-- /ko -->

  <!-- ko if: type() == 'SPARK' -->
    <div data-bind="template: { name: 'job-spark-page', data: $root.job() }"></div>
  <!-- /ko -->
</script>

<script type="text/html" id="job-yarn-page">
  <h2>YARN</h2>
  <br/>

  ${ _('Id') } <span data-bind="text: id"></span>
  ${ _('Name') } <span data-bind="text: name"></span>
  ${ _('Type') } <span data-bind="text: type"></span>
  ${ _('Status') } <span data-bind="text: status"></span>
  ${ _('User') } <span data-bind="text: user"></span>
  ${ _('Progress') } <span data-bind="text: progress"></span>
  ${ _('Duration') } <span data-bind="text: duration"></span>
  ${ _('Submitted') } <span data-bind="text: submitted"></span>
</script>

<script type="text/html" id="job-mapreduce-page">
  <h2>MapReduce</h2>
  <br/>

  ${ _('Id') } <span data-bind="text: id"></span>
  ${ _('Name') } <span data-bind="text: name"></span>
  ${ _('Type') } <span data-bind="text: type"></span>
  ${ _('Status') } <span data-bind="text: status"></span>
  ${ _('User') } <span data-bind="text: user"></span>
  ${ _('Progress') } <span data-bind="text: progress"></span>
  ${ _('Duration') } <span data-bind="text: duration"></span>
  ${ _('Submitted') } <span data-bind="text: submitted"></span>
</script>

<script type="text/html" id="job-impala-page">
  <h2>Impala</h2>
  <br/>

  ${ _('Id') } <span data-bind="text: id"></span>
  ${ _('Name') } <span data-bind="text: name"></span>
  ${ _('Type') } <span data-bind="text: type"></span>
  ${ _('Status') } <span data-bind="text: status"></span>
  ${ _('User') } <span data-bind="text: user"></span>
  ${ _('Progress') } <span data-bind="text: progress"></span>
  ${ _('Duration') } <span data-bind="text: duration"></span>
  ${ _('Submitted') } <span data-bind="text: submitted"></span>
</script>

<script type="text/html" id="job-spark-page">
  <h2>Spark</h2>
  <br/>

  ${ _('Id') } <span data-bind="text: id"></span>
  ${ _('Name') } <span data-bind="text: name"></span>
  ${ _('Type') } <span data-bind="text: type"></span>
  ${ _('Status') } <span data-bind="text: status"></span>
  ${ _('User') } <span data-bind="text: user"></span>
  ${ _('Progress') } <span data-bind="text: progress"></span>
  ${ _('Duration') } <span data-bind="text: duration"></span>
  ${ _('Submitted') } <span data-bind="text: submitted"></span>
</script>


<script type="text/html" id="batch-page">
  <h2>Workflow</h2>
  <br/>

  ${ _('Id') } <span data-bind="text: id"></span>
  ${ _('Name') } <span data-bind="text: name"></span>
  ${ _('Type') } <span data-bind="text: type"></span>
  ${ _('Status') } <span data-bind="text: status"></span>
  ${ _('User') } <span data-bind="text: user"></span>
  ${ _('Progress') } <span data-bind="text: progress"></span>
  ${ _('Duration') } <span data-bind="text: duration"></span>
  ${ _('Submitted') } <span data-bind="text: submitted"></span>
</script>

<script type="text/html" id="schedule-page">
  <h2>Schedule > Instance</h2>
  <br/>

  ${ _('Id') } <span data-bind="text: id"></span>
  ${ _('Name') } <span data-bind="text: name"></span>
  ${ _('Type') } <span data-bind="text: type"></span>
  ${ _('Status') } <span data-bind="text: status"></span>
  ${ _('User') } <span data-bind="text: user"></span>
  ${ _('Progress') } <span data-bind="text: progress"></span>
  ${ _('Duration') } <span data-bind="text: duration"></span>
  ${ _('Submitted') } <span data-bind="text: submitted"></span>
</script>


<script type="text/javascript" charset="utf-8">
  require([
    "knockout",
    "ko.charts",
    "desktop/js/apiHelper",
    "notebook/js/notebook.ko",
    "knockout-mapping",
    "knockout-sortable",
    "ko.editable",
    "ko.hue-bindings"
  ], function (ko, charts, ApiHelper, EditorViewModel) {

    var Job = function (vm, job) {
      var self = this;

      self.id = ko.observable(typeof job.id != "undefined" && job.id != null ? job.id : null);
      self.name = ko.observable(typeof job.name != "undefined" && job.name != null ? job.name : null);
      self.type = ko.observable(typeof job.type != "undefined" && job.type != null ? job.type : null);
      self.status = ko.observable(typeof job.status != "undefined" && job.status != null ? job.status : null);
      self.user = ko.observable(typeof job.user != "undefined" && job.user != null ? job.user : null);
      self.cluster = ko.observable(typeof job.cluster != "undefined" && job.cluster != null ? job.cluster : null);
      self.progress = ko.observable(typeof job.progress != "undefined" && job.progress != null ? job.progress : null);
      self.duration = ko.observable(typeof job.duration != "undefined" && job.duration != null ? job.duration : null);
      self.submitted = ko.observable(typeof job.submitted != "undefined" && job.submitted != null ? job.submitted : null);

      self.properties = ko.observable(typeof job.properties != "undefined" && job.properties != null ? job.properties : {});
      self.mainType = ko.observable(vm.interface());

      self.loadingJob = ko.observable(false);

      self.fetchJob = function () {
        self.loadingJob(true);
        vm.section('app');
        $.post("/jobbrowser/api/job", {
          appid: ko.mapping.toJSON(self.id),
          interface: ko.mapping.toJSON(vm.interface)
        }, function(data) {
          if (data.status == 0) {
            vm.job(new Job(vm, job));
          } else {
            $(document).trigger("error", data.message);
          }
        }).always(function(){
          self.loadingJob(false);
        });
      };
    };

    var Jobs = function (vm, options) {
      var self = this;

      self.apps = ko.observableArray();
      self.loadingJobs = ko.observable(false);

      self.username = ko.observable('${ user.username }');

      self.fetchJobs = function () {
        self.loadingJobs(true);
        vm.section('apps');
        $.post("/jobbrowser/api/jobs", {
          username: ko.mapping.toJSON(self.username),
          interface: ko.mapping.toJSON(vm.interface)
        }, function(data) {
          if (data.status == 0) {
            var apps = [];
            if (data && data.apps) {
              data.apps.forEach(function(job) { // TODO: update and merge
                apps.push(new Job(vm, job));
              });
            }
            self.apps(apps);
          } else {
            $(document).trigger("error", data.message);
          }
        }).always(function(){
          self.loadingJobs(false);
        });
      };
    }

    var JobBrowserViewModel = function (options) {
      var self = this;

      self.jobs = new Jobs(self, options);
      self.job = ko.observable();

      self.section = ko.observable('apps');
      self.interface = ko.observable('jobs');
      self.interface.subscribe(function(val) {
        self.jobs.fetchJobs();
      });
    };

    var viewModel;

    $(document).ready(function () {
      var options = {
        user: '${ user.username }',
        i18n: {
          errorLoadingDatabases: "${ _('There was a problem loading the databases') }",
        }
      }
      viewModel = new JobBrowserViewModel(options);
      ko.applyBindings(viewModel);

      viewModel.jobs.fetchJobs();
    });
  });
</script>

${ commonfooter(request, messages) | n,unicode }
