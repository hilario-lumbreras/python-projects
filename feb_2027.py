def send_request(latitude, longitude):
    wkid = 4326
    units = 'Meters'
    includeDate = False
    url = f'https://epqs.nationalmap.gov/v1/json?x={longitude}&y={latitude}&wkid={wkid}&units={units}&includeDate={includeDate}'
    response = urllib.request.urlopen(url)
    response_string = response.read().decode('utf-8')
    response_dict = json.loads('{' + response_string.split('{', 1)[1])
    value = response_dict['value']
    value = float(value)
    return value
