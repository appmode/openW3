// test for unsupported browsers (ie. IE) and redirect
test = document.createElement('input');
if (!('placeholder' in test))
{
	document.getElementById('or-bad-browser').style.display = 'block';
	document.getElementById('or-splash').onclick = "";
}
