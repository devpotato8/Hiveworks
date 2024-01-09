/**
 * 전자문서 기안페이지에서 사용하는 JS 모음
 * 작성자 : 이재연
 */
class ElectronicDocumentImageUploadAdapter{
	constructor(loader){
		this.loader = loader;
	}
	// Starts the upload process.
    upload() {
        return this.loader.file
            .then( file => new Promise( ( resolve, reject ) => {
                this._initRequest();
                this._initListeners( resolve, reject, file );
                this._sendRequest( file );
            } ) );
    }

    // Aborts the upload process.
    abort() {
        if ( this.xhr ) {
            this.xhr.abort();
        }
    }

    // Initializes the XMLHttpRequest object using the URL passed to the constructor.
    _initRequest() {
        const xhr = this.xhr = new XMLHttpRequest();

        // Note that your request may look different. It is up to you and your editor
        // integration to choose the right communication channel. This example uses
        // a POST request with JSON as a data structure but your configuration
        // could be different.
        xhr.open( 'POST', path+'/edoc/imgupload', true );
        xhr.responseType = 'json';
    }

    // Initializes XMLHttpRequest listeners.
    _initListeners( resolve, reject, file ) {
        const xhr = this.xhr;
        const loader = this.loader;
        const genericErrorText = `파일 업로드에 실패했습니다.:${ file.name }`;

        xhr.addEventListener( 'error', () => reject( genericErrorText ) );
        xhr.addEventListener( 'abort', () => reject() );
        xhr.addEventListener( 'load', () => {
            const response = xhr.response;

            // This example assumes the XHR server's "response" object will come with
            // an "error" which has its own "message" that can be passed to reject()
            // in the upload promise.
            //
            // Your integration may handle upload errors in a different way so make sure
            // it is done properly. The reject() function must be called when the upload fails.
            if ( !response || response.error ) {
                return reject( response && response.error ? response.error.message : genericErrorText );
            }

            // If the upload is successful, resolve the upload promise with an object containing
            // at least the "default" URL, pointing to the image on the server.
            // This URL will be used to display the image in the content. Learn more in the
            // UploadAdapter#upload documentation.
            resolve( {
                default: response.url
            } );
        } );

        // Upload progress when it is supported. The file loader has the #uploadTotal and #uploaded
        // properties which are used e.g. to display the upload progress bar in the editor
        // user interface.
        if ( xhr.upload ) {
            xhr.upload.addEventListener( 'progress', evt => {
                if ( evt.lengthComputable ) {
                    loader.uploadTotal = evt.total;
                    loader.uploaded = evt.loaded;
                }
            } );
        }
    }

    // Prepares the data and sends the request.
    _sendRequest( file ) {
        // Prepare the form data.
        const data = new FormData();

        data.append( 'upload', file );

        // Important note: This is the right place to implement security mechanisms
        // like authentication and CSRF protection. For instance, you can use
        // XMLHttpRequest.setRequestHeader() to set the request headers containing
        // the CSRF token generated earlier by your application.

        // Send the request.
        this.xhr.send( data );
    }
}

function ElectronicDocumentImageUploadAdapterPlugin( editor ) {
    editor.plugins.get( 'FileRepository' ).createUploadAdapter = ( loader ) => {
        // Configure the URL to the upload script in your back-end here!
        return new ElectronicDocumentImageUploadAdapter( loader );
    };
}

DecoupledEditor
.create( document.querySelector("#content"),{
	extraPlugins :[ElectronicDocumentImageUploadAdapterPlugin]
})
	.then( editor => {
            const toolbarContainer = document.querySelector( '.editor-toolbar-container' );

            toolbarContainer.appendChild( editor.ui.view.toolbar.element );
        } )
        .catch( error => {
            console.error( error );
        } );
        
        
 $('#edocType').on('change',(e)=>{
	const $format = $('#edocFormat');
	fetch(path+"/edoc/formatList?edocDotCode="+e.target.value)
	.then(response=>{
		if(response.status != 200) throw new Error(response.status);
		return response.json();
	})
	.then(result =>{
		$format.html("");
		$format.append($('<option disabled="disabled" selected="selected">').text('서식종류'));
		
		result.forEach((v,i)=>{
			$format.append($('<option>').val(v.sampleNo).text(v.sampleName));
		});
	})
	.catch(e=>{
		alert(e);
		console.log(e);
	});
});

$('#edocFormat').on('change',(e)=>{
	let processContinue = confirm('작성중인 내용이 전부 사라질 수 있습니다. 진행하시겠습니까?');
	const edocFormatNo = e.target.value;
	if(processContinue){
		fetch(path+"/edoc/formatData?formatNo="+edocFormatNo)
		.then(response=>{
			if(response.status != 200) throw new Error(response.status)
			return response.json();
		})
		.then(data=>{
			console.log(data);
			document.getElementById('content').ckeditorInstance.data.set(data.sampleContent);
		})
		.catch(e=>{
				alert(e);
				console.log(e);
			})
	}
});

$('#submitButton').on('click',()=>{
	const edoc  = {
				edocTitle : $('#edocTitle').val(),
				edocDotCode : $('#edocType').val(),
				edocDsgCode : $('#edocDsgCode').val(),
				creater : $('#edocCreter').val(),
				period : $('#period').val(),
				edocContent : $('#content').html()
			};
	fetch(path+'/edoc/write',{
		method : 'post',
		headers: {
      		"Content-Type": "application/json",
    	},
    	body : JSON.stringify(edoc)
	})
	.then(response =>{
		if(response.status != 200) throw new Error(response.status);
		return response.json();
	})
	.then(data=>{
		alert('문서가 정상적으로 기안되었습니다.\n문서번호 : '+data.edocNo);
		location.replace(path+"/edoc/lists/process");
	})
	.catch(e=>{
		alert(e);
		console.log(e);
	})
});
