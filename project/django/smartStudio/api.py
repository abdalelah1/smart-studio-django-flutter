from django.http import JsonResponse
def check_connection(request):
    response = {
        'status': 'success',
        'message': 'Connection successful',
    }
    return JsonResponse(response)   
