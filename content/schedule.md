+++
title = "Programma e Contenuti"
date = 2025-08-26
+++

<link rel="stylesheet" href="/schedule.css">

# Programma

## Resta Aggiornato

Il programma di `ESC {21}` è in fase di definizione, quindi questa pagina e' in continuo aggiornamento. Controlla nuovamente questa pagina piu' avanti per tenerti aggiornato sugli eventi, i talk e i laboratori che si terranno durante l'evento!

Inoltre, puoi vedere lo schedule attuale (in allestimento!) sul **[Calendario di Pretalx](https://pretalx.endsummer.camp/2K25/schedule/)**.
A breve verra' pubblicato lo schedule finale.

## Contribuisci all'ESC!

La prima regola dell'ESC è: _"Porta all'ESC quello che vorresti vedere all'ESC!"_  
Per proporre un talk o un laboratorio, visita la nostra Call for Papers (CFP) su [Pretalx](https://pretalx.endsummer.camp/2K25/cfp).

# Contenuti

<div id="schedule">
</div>

<script>
    // Mostra lo spinner all'avvio
    document.getElementById('schedule').innerHTML = '<div class="spinner"></div><span style="text-align: center;">Sto caricando il programma...</span>';

    fetch('https://pretalx.endsummer.camp/2K25/schedule/export/schedule.xml')
        .then(r => r.text())
        .then(xmlText => {
            const parser = new DOMParser();
            const xml = parser.parseFromString(xmlText, "application/xml");
            const days = xml.querySelectorAll('day');
            // Raggruppa gli eventi per track
            const tracks = {
                'Talk': [],
                'Project / Lab': [],
                'Music': []
            };
            days.forEach(day => {
                const date = day.getAttribute('date');
                day.querySelectorAll('room').forEach(room => {
                    const roomName = room.getAttribute('name');
                    room.querySelectorAll('event').forEach(event => {
                        const title = event.querySelector('title')?.textContent || '';
                        const start = event.querySelector('start')?.textContent || '';
                        const duration = event.querySelector('duration')?.textContent || '';
                        const track = event.querySelector('track')?.textContent || '';
                        const abstract = event.querySelector('abstract')?.textContent || '';
                        const url = event.querySelector('url')?.textContent || '';
                        const persons = Array.from(event.querySelectorAll('persons person')).map(p => p.textContent).join(', ');
                        const eventHtml = `
                            <div class="event">
                                <div class=""><strong>${title}</strong></div>
                                <div class="time">${date} ${start} (durata ${duration})</div>
                                <div class="room">Sala: ${roomName}</div>
                                <div class="persons">Relatori: ${persons}</div>
                                <a class="link" href="${url}" target="_blank">Dettagli</a>
                                <a class="ical-link" href="#" onclick="downloadICS(event, {
                                    title: \`${title.replace(/`/g, "\\`")}\`,
                                    date: \`${date}\`,
                                    start: \`${start}\`,
                                    duration: \`${duration}\`,
                                    room: \`${roomName.replace(/`/g, "\\`")}\`,
                                    persons: \`${persons.replace(/`/g, "\\`")}\`,
                                    url: \`${url}\`,
                                    description: \`${abstract.replace(/`/g, "\\`")}\`
                                })">Scarica iCal</a>
                            </div>
                        `;
                        if (track === 'Talk') tracks['Talk'].push(eventHtml);
                        else if (track === 'Project / Lab') tracks['Project / Lab'].push(eventHtml);
                        else if (track === 'Music') tracks['Music'].push(eventHtml);
                    });
                });
            });
            let html = '';
            html += `<h2>Talk</h2>${tracks['Talk'].join('') || '<p>Nessun talk trovato.</p>'}`;
            html += `<h2>Project / Lab</h2>${tracks['Project / Lab'].join('') || '<p>Nessun progetto/lab trovato.</p>'}`;
            html += `<h2>Music</h2>${tracks['Music'].join('') || '<p>Nessun evento musicale trovato.</p>'}`;
            document.getElementById('schedule').innerHTML = html;
        })
        .catch(() => {
            document.getElementById('schedule').innerHTML = '<p>Impossibile caricare il programma.</p>';
        });

    function downloadICS(e, data) {
        e.preventDefault();
        // Calcola orario di fine
        function addDuration(start, duration) {
            const [h, m] = duration.split(':').map(Number);
            const date = new Date(`${data.date}T${data.start}`);
            date.setHours(date.getHours() + h);
            date.setMinutes(date.getMinutes() + m);
            return date.toISOString().replace(/[-:]/g, '').slice(0,15) + 'Z';
        }
        const dtStart = `${data.date.replace(/-/g, '')}T${data.start.replace(/:/g, '')}00Z`;
        const dtEnd = addDuration(data.start, data.duration);
        const icsContent = [
            'BEGIN:VCALENDAR',
            'VERSION:2.0',
            'PRODID:-//endsummercamp//ESC21//IT',
            'BEGIN:VEVENT',
            `SUMMARY:${data.title}`,
            `DESCRIPTION:${data.description}\\nRelatori: ${data.persons}\\nDettagli: ${data.url}`,
            `LOCATION:${data.room}`,
            `DTSTART:${dtStart}`,
            `DTEND:${dtEnd}`,
            `URL:${data.url}`,
            'END:VEVENT',
            'END:VCALENDAR'
        ].join('\r\n');
        const blob = new Blob([icsContent], { type: 'text/calendar' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `${data.title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}.ics`;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
</script>
<noscript>
    <p>Per visualizzare il programma, abilita JavaScript nel tuo browser o vai <a href="https://pretalx.endsummer.camp/2K25/schedule/nojs">sul calendario di Pretalx</a>.</p>
</noscript>