/**
 * Created by Summer on 7/6/2017.
 */
$(document).ready(function() {
    // detect if native date input is supported
    var nativeDateInputSupported = true;

    var input = document.createElement('input');
    input.setAttribute('type','date');
    if (input.type === 'text') {
        nativeDateInputSupported = false;
    }

    var notADateValue = 'not-a-date';
    input.setAttribute('value', notADateValue);
    if (input.value === notADateValue) {
        nativeDateInputSupported = false;
    }
    if(nativeDateInputSupported)
    {
        //console.log("test1");
        $("#start_date_area, #due_date_area").find('input:text').each(function () {
            //console.log("value:" + this.value);
            $("<input type='date' />").attr({name: this.name, size: this.size, id: this.id}).insertBefore(this).addClass('date').val($(this).val()).datepickerFallback(datepickerOptions2);
        }).remove();
    }
});