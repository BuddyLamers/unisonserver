;(function () {
  var me = {};

  me.init = function () {
    me.RowSelector.setUp();
    me.CsvUploader.init();
  };

  me.RowSelector = (function () {
    var me = {};
    var allRows = [];
    var selectedRows = [];
    var deselectedRows = [];
    var filteredRows = [];
    var $selector;
    var $selected;
    var $deselected;
    var $search;

    me.setUp = function () {
      var selector = $selector = $('.row-selector');

      $('.selected .row', selector).each(function () {
        var ob = {id: $(this).data('id'), name: $(this).text(), $el: $(this)};

        selectedRows.push(ob);
        allRows.push(ob);

        $(this).data('ob', ob);
      });

      $('.deselected .row', selector).each(function () {
        var id = $(this).data('id');
        var ob = {id: id, name: $(this).text(), $el: $(this)};

        $(this).data('ob', ob);

        if (_.find(selectedRows, function (ob2) {
          return ob2.id == ob.id;
        })) {
          $(this).remove();
        } else {
          deselectedRows.push(ob);
        }

        allRows.push(ob);
      });

      $selected = $('.selected', selector).on('click', '.row', me.clickSelected);
      $deselected = $('.deselected', selector).on('click', '.row', me.clickDeselected);
      $search = $('.search-deselected', selector).on('keydown', _.debounce(me.searchKeyDown, 100));
      $('.add-all', selector).on('click', me.addAll);
      $('.remove-all', selector).on('click', me.removeAll);
      selector.submit(me.submit);
    };

    me.clickSelected = function () {
      me.swapEl($(this), selectedRows, deselectedRows, $selected, $deselected);
      me.submit();
    };

    me.clickDeselected = function () {
      me.swapEl($(this), deselectedRows, selectedRows, $deselected, $selected);
      me.submit();
    };

    me.addAll = function () {
      selectedRows = allRows;
      deselectedRows = [];
      me.reset();
      me.submit();
    };

    me.removeAll = function () {
      selectedRows = [];
      deselectedRows = allRows;
      me.reset();
      me.submit();
    };

    me.reset = function () {
      var ob;
      for (var i = 0, l = selectedRows.length; i < l; i++) {
        ob = selectedRows[i];
        $selected.append(ob.$el);
      }
      for (var i = 0, l = deselectedRows.length; i < l; i++) {
        ob = deselectedRows[i];
        $deselected.append(ob.$el);
      }
    };

    me.swapEl = function ($el, from, to, $from, $to) {
      var id = $el.data('id'),
          ob = $el.data('ob'),
          index;

      from.splice(from.indexOf(ob), 1);

      index = _.sortedIndex(to, ob, function (ob) {
        return ob.name;
      });

      to.splice(index, 0, ob);

      if (index >= to.length) {
        $el.appendTo($to);
      } else if (index > 0) {
        $el.insertBefore($('.row', $to).eq(index - 1));
      } else {
        $el.prependTo($to);
      }
    };

    me.searchKeyDown = function (e) {
      var val = $search.val().trim().toLowerCase();

      if (!val) {
        filteredRows = deselectedRows;
      } else {
        filteredRows = _.filter(deselectedRows, function (row) {
          return row.name.toLowerCase().indexOf(val) > -1;
        });
      }

      me.populate();
    };

    me.populate = function () {
      var $row;
      var row;
      $rows = $();

      for (var i = 0, l = filteredRows.length; i < l; i++) {
        row = filteredRows[i];

        $row = $('<div class="row">' + row.name + '</div>');
        $row.data('id', row.id);
        $row.data('ob', row);

        $rows.push($row[0]);
      }

      $deselected.html($rows);
    };

    me.submit = function () {
      var data = {};
      data[$selected.data('name')] = _.pluck(selectedRows, 'id');

      $.ajax({
        url: $selector.attr('action'),
        method: 'put',
        data: data,
        dataType: 'json'
      });
    };

    return me;
  }());

  me.CsvUploader = (function () {
    var me = {};

    me.init = function () {
      $('.uploader').click(me.click);
      $('.modal .close').click(me.close);
    };

    me.click = function () {
      $('.modal-uploader').fadeIn(200);
    };

    me.close = function () {
      $('.modal').fadeOut(200);
    };

    return me;
  }());

  $(function () {
    me.init();
  });

}());
